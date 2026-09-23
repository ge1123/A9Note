#!/usr/bin/env bash
# Run with bash (compatible with macOS Bash 3.2). Default: read-only preview.
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: bash scripts/setup-github-environment.sh [--apply]
Required environment variables:
  LAB_SUBSCRIPTION  Explicit Azure subscription ID
  LAB_RG           Existing dedicated lab resource group
  LAB_AKS          Existing AKS name
  LAB_ACR          Existing ACR name
  LAB_GITHUB_REPO  GitHub owner/repository
Optional:
  LAB_DEPLOY_BRANCH  Branch allowed for a NEW environment (default: repo default branch)
Default previews only. --apply creates identity/OIDC/RBAC and GitHub aks-lab variables.
Does not create AKS/ACR, change Kubernetes, push code, or dispatch a workflow.
EOF
}
apply=false
case "${1:-}" in
  '') ;;
  --apply) apply=true ;;
  -h|--help) usage; exit 0 ;;
  *) usage >&2; exit 2 ;;
esac
[[ $# -le 1 ]] || { usage >&2; exit 2; }
for tool in az gh python3; do
  command -v "$tool" >/dev/null || { echo "Missing tool: $tool" >&2; exit 1; }
done
: "${LAB_SUBSCRIPTION:?Set LAB_SUBSCRIPTION}"
: "${LAB_RG:?Set LAB_RG}"
: "${LAB_AKS:?Set LAB_AKS}"
: "${LAB_ACR:?Set LAB_ACR}"
: "${LAB_GITHUB_REPO:?Set LAB_GITHUB_REPO}"
[[ "$LAB_GITHUB_REPO" =~ ^[a-zA-Z0-9_.-]+/[a-zA-Z0-9_.-]+$ ]] || { echo 'Expected owner/repository' >&2; exit 2; }
# Normalize repository casing to the canonical OIDC subject. Pin github.com explicitly.
export GH_HOST=github.com
repo=$(gh api "repos/$LAB_GITHUB_REPO" --jq .full_name)
admin=$(gh api "repos/$repo" --jq .permissions.admin)
[[ "$admin" == true ]] || { echo 'GitHub repository administrator access required.' >&2; exit 1; }
branch=${LAB_DEPLOY_BRANCH:-$(gh api "repos/$repo" --jq .default_branch)}
# Only literal branch names, not wildcard patterns, for new environment policy.
[[ "$branch" != *'*'* && "$branch" != *'?'* && "$branch" != *'['* ]] || { echo 'Use a literal deployment branch.' >&2; exit 2; }
encoded_branch=$(python3 -c 'import sys,urllib.parse; print(urllib.parse.quote(sys.argv[1],safe=""))' "$branch")
gh api "repos/$repo/branches/$encoded_branch" --silent
sub=$(az account show --subscription "$LAB_SUBSCRIPTION" --query id -o tsv)
tenant=$(az account show --subscription "$sub" --query tenantId -o tsv)
location=$(az group show --subscription "$sub" -n "$LAB_RG" --query location -o tsv)
aks_id=$(az aks show --subscription "$sub" -g "$LAB_RG" -n "$LAB_AKS" --query id -o tsv)
acr_id=$(az acr show --subscription "$sub" -g "$LAB_RG" -n "$LAB_ACR" --query id -o tsv)
environment=aks-lab
identity=id-dotnet-aks-github
subject="repo:$repo:environment:$environment"
existing=$(gh api --paginate "repos/$repo/environments?per_page=100" --jq '.environments[] | select(.name == "aks-lab") | .name')
cat <<EOF
Scope: $repo / $environment
Azure: $sub / $LAB_RG / $location
AKS: $LAB_AKS; ACR: $LAB_ACR
Create/reuse identity: $identity; OIDC subject: $subject
Grant identity: AcrPush on ACR; AKS Cluster User; AKS RBAC Writer on dotnet-lab only.
Set six environment variables used by the manual workflow.
Existing environment protection rules are preserved. New environment allows branch: $branch
No compute resources or workflow runs will be started. Existing Azure resources keep billing.
Cleanup: delete the dedicated lab RG and GitHub environment as documented in README.
EOF
if ! "$apply"; then
  echo 'Preview complete. Run again with --apply to write these settings.'
  exit 0
fi

# Create only when absent: avoid resetting existing reviewers or branch policies.
if [[ -z "$existing" ]]; then
  gh api --method PUT "repos/$repo/environments/$environment" --input - --silent <<'JSON'
{"deployment_branch_policy":{"protected_branches":false,"custom_branch_policies":true}}
JSON
  gh api --method POST "repos/$repo/environments/$environment/deployment-branch-policies" \
    -f name="$branch" -f type=branch --silent
else
  echo 'Reusing environment; review its existing branch/reviewer rules in GitHub Settings.'
fi

# Listing failures stop the script, rather than being treated as a missing identity.
identity_id=$(az identity list --subscription "$sub" -g "$LAB_RG" --query "[?name=='$identity'].id | [0]" -o tsv)
if [[ -z "$identity_id" ]]; then
  az identity create --subscription "$sub" -g "$LAB_RG" -n "$identity" --location "$location" -o none
fi
client=$(az identity show --subscription "$sub" -g "$LAB_RG" -n "$identity" --query clientId -o tsv)
principal=$(az identity show --subscription "$sub" -g "$LAB_RG" -n "$identity" --query principalId -o tsv)
federation=$(az identity federated-credential list --subscription "$sub" -g "$LAB_RG" --identity-name "$identity" --query "[?name=='github-aks-lab']" -o json)
# Never overwrite a different trust relationship under the same name.
printf '%s' "$federation" | python3 -c '
import json,sys
items=json.load(sys.stdin)
if items:
    f=items[0]
    if (f["subject"] != sys.argv[1] or f["issuer"] != "https://token.actions.githubusercontent.com"
        or f["audiences"] != ["api://AzureADTokenExchange"]):
        sys.exit("Existing github-aks-lab trust differs; inspect it before proceeding.")
' "$subject"
if [[ "$federation" == '[]' ]]; then
  az identity federated-credential create --subscription "$sub" -g "$LAB_RG" \
    --identity-name "$identity" --name github-aks-lab \
    --issuer https://token.actions.githubusercontent.com --subject "$subject" \
    --audiences api://AzureADTokenExchange -o none
fi

ensure_role() {
  local role="$1" scope="$2" count
  count=$(az role assignment list --subscription "$sub" --scope "$scope" \
    --query "length([?principalId=='$principal' && roleDefinitionName=='$role'])" -o tsv)
  if [[ "$count" == 0 ]]; then
    az role assignment create --subscription "$sub" --assignee-object-id "$principal" \
      --assignee-principal-type ServicePrincipal --role "$role" --scope "$scope" -o none
  fi
}
ensure_role AcrPush "$acr_id"
ensure_role 'Azure Kubernetes Service Cluster User Role' "$aks_id"
ensure_role 'Azure Kubernetes Service RBAC Writer' "$aks_id/namespaces/dotnet-lab"

set_variable() {
  gh variable set "$1" --repo "$repo" --env "$environment" --body "$2"
}
set_variable AZURE_CLIENT_ID "$client"
set_variable AZURE_TENANT_ID "$tenant"
set_variable AZURE_SUBSCRIPTION_ID "$sub"
set_variable AZURE_RESOURCE_GROUP "$LAB_RG"
set_variable AKS_NAME "$LAB_AKS"
set_variable ACR_NAME "$LAB_ACR"

# Verify values without printing IDs/tokens. A partial failure can be rerun.
verify_variable() {
  local actual
  actual=$(gh api "repos/$repo/environments/$environment/variables/$1" --jq .value)
  [[ "$actual" == "$2" ]] || { echo "Verification failed: $1" >&2; exit 1; }
}
verify_variable AZURE_CLIENT_ID "$client"
verify_variable AZURE_TENANT_ID "$tenant"
verify_variable AZURE_SUBSCRIPTION_ID "$sub"
verify_variable AZURE_RESOURCE_GROUP "$LAB_RG"
verify_variable AKS_NAME "$LAB_AKS"
verify_variable ACR_NAME "$LAB_ACR"
echo 'Environment and six variables verified. Allow time for Azure RBAC propagation.'
echo 'Next: ensure dotnet-lab namespace exists, then manually select Run workflow.'
