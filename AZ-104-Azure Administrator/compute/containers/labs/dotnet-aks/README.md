# .NET API → ACR → AKS

對應 [Azure Containers #28](https://github.com/ge1123/Microsoft-Azure/issues/28)，回到[主題筆記](../../README.md)。這是後端部署延伸 lab，不代表完成 AZ-104 考綱。

## 範圍與狀態

2026-09-23 建立；revision：本次 working tree，尚未 commit。Azure 與 GitHub Actions runtime **待驗證**。本機驗證見文末。上一輪 scaling lab 已刪除，本輪使用獨立 resource group。

- [Program.cs](src/LabApi/Program.cs)：無狀態 .NET 10 HTTP API、JSON console logs、健康檢查。
- [Dockerfile](Dockerfile)：多階段建置、非 root、8080。
- [main.bicep](infra/main.bicep)：ACR Basic、AKS Free、Entra/Azure RBAC、kubelet AcrPull、2–3 nodes。
- [app.yaml](k8s/app.yaml)：Deployment、ClusterIP Service、ConfigMap、HPA、PDB、probes。
- [手動 workflow](../../../../../.github/workflows/dotnet-aks-lab.yml)：OIDC → build/push AMD64 → digest 部署 → rollout 與 HTTP 檢查。只有 workflow_dispatch，沒有 push、PR 或 schedule trigger；既有 Pages workflow 維持原行為。

## 成本與限制

執行位置：本機 repository 根目錄。先完成本機驗證，再建立雲端資源。Bicep 對你指定的專用 RG 建立 ACR、AKS，AKS 另建立 managed node RG（VM、disks、outbound LB/public IP）。建立者需要建立資源與 role assignment 的權限；OIDC 步驟另外建立專用 managed identity 與 federated credential。

Free 是 AKS 管理層，VM、64 GiB OS disks、ACR Basic、LB/IP、流量與可能的 Actions 用量仍計費。Standard_D4as_v5 沿用前輪可用選項，並非保證所有區域最低價。預設兩台、最多三台；先確認 East Asia SKU 可用性與 DASv5/總 CPU 配額至少 12 vCPU。升級 surge 可能需要額外配額。請依當日 [Azure calculator](https://azure.microsoft.com/pricing/calculator/) 核價。

此版讓應用共用 system pool 以節省練習成本，沒有 DB、Key Vault、Ingress、DNS/TLS、長期監控或跨區容災。API 只透過 port-forward 存取；AKS API 和 ACR 使用需驗證的公開端點。PDB 只限制自願中斷，不保證所有故障下可用。正式環境應另外設計 user pool、存取邊界與可觀測性。

## 1. 本機執行

```bash
export LAB_PATH="AZ-104-Azure Administrator/compute/containers/labs/dotnet-aks"
dotnet run --project "$LAB_PATH/src/LabApi" --urls http://127.0.0.1:5080
```

另一個終端：

```bash
curl --fail http://127.0.0.1:5080/info
curl --fail http://127.0.0.1:5080/health/ready
```

Ctrl+C 停止。Mac ARM 可先建 native image 測試；AKS 的 D4as_v5 是 AMD64，workflow 明確建 linux/amd64。

```bash
docker build -t lab-api:local "$LAB_PATH"
docker run --rm --read-only --tmpfs /tmp:rw,nosuid,size=64m -p 127.0.0.1:5080:8080 lab-api:local
```

`/info` 顯示版本、instance、訊息與時間。兩個 health endpoint 目前只證明 HTTP process 能回應；加入 DB 後再設計 readiness 依賴檢查，liveness 不應直接綁 DB 存活。

## 2. 確認 scope，再建立基礎設施

以下 placeholder 要自行替換，不會從既有登入猜 subscription。名稱是本輪建議值，執行前確認使用專用 RG；不要填入含其他資源的 RG。

```bash
export LAB_SUBSCRIPTION="<確認的 subscription ID>"
export LAB_LOCATION="eastasia"
export LAB_RG="rg-dotnet-aks-lab"
export LAB_AKS="aks-dotnet-lab"
export LAB_ACR="<全球唯一小寫英數 ACR 名稱>"
az account show --subscription "$LAB_SUBSCRIPTION" --query '{name:name,tenant:tenantId}' -o table
az aks get-versions --subscription "$LAB_SUBSCRIPTION" --location "$LAB_LOCATION" -o table
az vm list-usage --subscription "$LAB_SUBSCRIPTION" --location "$LAB_LOCATION" -o table
az vm list-skus --subscription "$LAB_SUBSCRIPTION" --location "$LAB_LOCATION" --size Standard_D4as_v5 --all --query '[].{name:name,restrictions:restrictions}' -o json
export LAB_K8S_VERSION="<上面列出的受支援 1.35.x 版本>"
```

Workflow kubectl 固定 1.35.0；若改用其他 Kubernetes minor，需同步確認 client/server version skew。

```bash
az provider register --subscription "$LAB_SUBSCRIPTION" --namespace Microsoft.ContainerService --wait
az provider register --subscription "$LAB_SUBSCRIPTION" --namespace Microsoft.ContainerRegistry --wait
az provider register --subscription "$LAB_SUBSCRIPTION" --namespace Microsoft.ManagedIdentity --wait
az group create --subscription "$LAB_SUBSCRIPTION" --name "$LAB_RG" --location "$LAB_LOCATION" -o none
az deployment group what-if --subscription "$LAB_SUBSCRIPTION" --resource-group "$LAB_RG" --template-file "$LAB_PATH/infra/main.bicep" --parameters location="$LAB_LOCATION" aksName="$LAB_AKS" acrName="$LAB_ACR" kubernetesVersion="$LAB_K8S_VERSION"
```

閱讀 what-if 後，手動執行正式建立（從此開始有資源費用）：

```bash
az deployment group create --subscription "$LAB_SUBSCRIPTION" --resource-group "$LAB_RG" --name dotnet-aks --template-file "$LAB_PATH/infra/main.bicep" --parameters location="$LAB_LOCATION" aksName="$LAB_AKS" acrName="$LAB_ACR" kubernetesVersion="$LAB_K8S_VERSION" --query properties.provisioningState -o tsv
export LAB_AKS_ID=$(az aks show --subscription "$LAB_SUBSCRIPTION" -g "$LAB_RG" -n "$LAB_AKS" --query id -o tsv)
export LAB_ACR_ID=$(az acr show --subscription "$LAB_SUBSCRIPTION" -g "$LAB_RG" -n "$LAB_ACR" --query id -o tsv)
export LAB_OPERATOR_ID=$(az ad signed-in-user show --query id -o tsv)
az role assignment create --subscription "$LAB_SUBSCRIPTION" --assignee-object-id "$LAB_OPERATOR_ID" --assignee-principal-type User --role "Azure Kubernetes Service RBAC Cluster Admin" --scope "$LAB_AKS_ID" -o none
```

最後一行授權目前互動式登入使用者管理本 lab cluster；若使用 service principal 登入，需改成該身分的 object ID/type。建立者也需要 Cluster User Role（Owner/Contributor 已含讀取 user credentials 能力）。安裝 kubelogin（macOS：`brew install Azure/kubelogin/kubelogin`），建立獨立 kubeconfig：

```bash
mkdir -p "$HOME/.kube"
export KUBECONFIG=$(mktemp "$HOME/.kube/dotnet-aks.XXXXXX")
az aks get-credentials --subscription "$LAB_SUBSCRIPTION" -g "$LAB_RG" -n "$LAB_AKS" --file "$KUBECONFIG"
kubelogin convert-kubeconfig -l azurecli
kubectl create namespace dotnet-lab --dry-run=client -o yaml | kubectl apply -f -
```

RBAC 傳播可能要數分鐘；Forbidden 時先等候並檢查 role scope，不要改用 admin credentials。本 lab 禁止 local accounts。

## 3. 一次性設定 GitHub OIDC

### 使用 .sh（建議）

完成第 2 節的 AKS、ACR、namespace 後，可以用 [setup-github-environment.sh](scripts/setup-github-environment.sh) 取代下方手動 OIDC／variables 步驟。`aks-lab` 是 GitHub environment；`dotnet-lab` 是 Kubernetes namespace，兩者不同。

前提：本機安裝 `az`、`gh`、`python3`，完成 `az login` 與 `gh auth login --hostname github.com`。GitHub 登入者需要 repository 管理權限，token 需能管理 environments 和 Actions variables（fine-grained token 的 Administration、Variables write）；Azure 登入者需要建立 managed identity/federated credential 與指定 scopes 的 role assignment 權限。

從 repository 根目錄執行，沿用第 2 節的 LAB_SUBSCRIPTION、LAB_RG、LAB_AKS、LAB_ACR：

```bash
export LAB_PATH="AZ-104-Azure Administrator/compute/containers/labs/dotnet-aks"
export LAB_GITHUB_REPO="ge1123/Microsoft-Azure"
# 可選：指定已推送的部署分支；未設時使用 repository default branch。
# export LAB_DEPLOY_BRANCH="note-202609"
bash "$LAB_PATH/scripts/setup-github-environment.sh"
```

預覽會唯讀查詢實際 subscription、resources、repository 與分支；不建立付費資源。確認顯示的 scope 後套用：

```bash
bash "$LAB_PATH/scripts/setup-github-environment.sh" --apply
```

套用建立／重用 `id-dotnet-aks-github`、OIDC credential、三個限定範圍的 role assignments、GitHub `aks-lab` environment 與六個 variables，再讀回驗證。它不會建立 AKS/ACR、推送程式或觸發 workflow；既有 Azure 資源繼續計費。新 environment 限制允許的分支；既有 environment 保留 reviewers、branch rules 等設定，請確認你要部署的分支已被允許。

同名 OIDC trust 若與本次 repo 不一致會停止，不覆寫。中途失敗可能留下已建立項目，可修正權限後重跑；若剛建立 environment 後 branch-policy API 失敗，先在 GitHub Settings 補上允許的分支（重跑保留既有 protection rules）。不會產生 client secret。清理方式仍見第 5 節：刪除 lab RG 及 GitHub environment。

### 手動指令（供學習對照；已跑腳本可跳過）

GitHub repository Settings → Environments 建立 `aks-lab`，限制允許部署的分支；依需要設定 reviewer。Workflow 檔必須先存在 default branch，才可從 Actions UI 手動選分支執行。本輪不自動 commit、push 或觸發。

以下建立 managed identity（不建立 client secret）；GitHub repo 值要填實際 owner/repository。

```bash
export LAB_GITHUB_REPO="<owner/repository>"
az identity create --subscription "$LAB_SUBSCRIPTION" -g "$LAB_RG" -n id-dotnet-aks-github -o none
export LAB_CLIENT_ID=$(az identity show --subscription "$LAB_SUBSCRIPTION" -g "$LAB_RG" -n id-dotnet-aks-github --query clientId -o tsv)
export LAB_PRINCIPAL_ID=$(az identity show --subscription "$LAB_SUBSCRIPTION" -g "$LAB_RG" -n id-dotnet-aks-github --query principalId -o tsv)
az identity federated-credential create --subscription "$LAB_SUBSCRIPTION" -g "$LAB_RG" --identity-name id-dotnet-aks-github --name github-aks-lab --issuer https://token.actions.githubusercontent.com --subject "repo:${LAB_GITHUB_REPO}:environment:aks-lab" --audiences api://AzureADTokenExchange -o none
az role assignment create --subscription "$LAB_SUBSCRIPTION" --assignee-object-id "$LAB_PRINCIPAL_ID" --assignee-principal-type ServicePrincipal --role AcrPush --scope "$LAB_ACR_ID" -o none
az role assignment create --subscription "$LAB_SUBSCRIPTION" --assignee-object-id "$LAB_PRINCIPAL_ID" --assignee-principal-type ServicePrincipal --role "Azure Kubernetes Service Cluster User Role" --scope "$LAB_AKS_ID" -o none
az role assignment create --subscription "$LAB_SUBSCRIPTION" --assignee-object-id "$LAB_PRINCIPAL_ID" --assignee-principal-type ServicePrincipal --role "Azure Kubernetes Service RBAC Writer" --scope "$LAB_AKS_ID/namespaces/dotnet-lab" -o none
```

GitHub environment `aks-lab` → Variables 新增以下值（不是 client secret，不要提交實際環境輸出）：

| Variable | 值 |
| --- | --- |
| AZURE_CLIENT_ID | LAB_CLIENT_ID |
| AZURE_TENANT_ID | 已確認 subscription 的 tenant ID |
| AZURE_SUBSCRIPTION_ID | LAB_SUBSCRIPTION |
| AZURE_RESOURCE_GROUP | LAB_RG |
| AKS_NAME | LAB_AKS |
| ACR_NAME | LAB_ACR |

Workflow 身分只能 push 此 ACR、取得此 AKS user config、寫入 dotnet-lab namespace；namespace 已由操作者建立，因此 workflow 無需 cluster admin 或 subscription Contributor。kubelet 使用另一個身分拉取映像，Bicep 已授予 AcrPull。

## 4. 手動部署與觀察

Actions → Deploy .NET AKS lab (manual) → Run workflow。建置 tag 包含 commit/run/attempt，部署使用 digest，失敗會回報而不自動 rollback。首次 AcrPull/AcrPush RBAC 傳播中可能需要等候後重試。

```bash
kubectl get deployment,pods,svc,hpa,pdb -n dotnet-lab
kubectl port-forward -n dotnet-lab service/lab-api 5080:80
```

另一終端 `curl --fail http://127.0.0.1:5080/info`。port-forward 固定轉到某一個 Pod，不能用它證明多 Pod 負載平衡。Workflow 的 HTTP smoke check 也只驗證其中一個 instance。

可練習修改 APP_MESSAGE、更新程式後手動再次觸發，以及故意改錯 readiness port 後觀察舊 Pod 保留。ConfigMap env 修改不會更新既有 process，需 `kubectl rollout restart deployment/lab-api -n dotnet-lab`。回復 Deployment：

```bash
kubectl rollout undo deployment/lab-api -n dotnet-lab
kubectl rollout status deployment/lab-api -n dotnet-lab --timeout=300s
```

Rollback 只回復 Pod template，不會回復 ConfigMap、HPA 或 Bicep。下一次 workflow 仍以該 commit 的設定部署，必須先修正來源。HPA 不設定 Deployment replicas，避免每次 apply 重設目前副本數。

## 5. 清理

先記錄 managed node RG 名稱，確認 LAB_RG 是本輪專用 RG；下列會刪除本 lab API、AKS、ACR 中所有映像和 workflow identity。

```bash
export LAB_NODE_RG=$(az aks show --subscription "$LAB_SUBSCRIPTION" -g "$LAB_RG" -n "$LAB_AKS" --query nodeResourceGroup -o tsv)
az group delete --subscription "$LAB_SUBSCRIPTION" --name "$LAB_RG" --yes
az group exists --subscription "$LAB_SUBSCRIPTION" --name "$LAB_RG"
az group exists --subscription "$LAB_SUBSCRIPTION" --name "$LAB_NODE_RG"
```

兩個 false 才是這兩個 RG 已刪除的證據。另移除 GitHub `aks-lab` environment 的 variables/environment；本機專用 kubeconfig 確認路徑後刪除。不要刪除原有 `~/.kube/config`。

## 驗證紀錄

- 2026-09-23，macOS ARM64：.NET SDK 10.0.201、Docker 29.2.1、Buildx 0.31.1、Bicep 0.46.1 可用。
- Bicep 本機 build 通過；尚未執行 Azure what-if/deployment。
- `dotnet build -c Release`：0 warnings、0 errors。
- `docker buildx build --platform linux/amd64 --load` 成功；測試容器使用 read-only rootfs、tmpfs /tmp、cap-drop ALL、no-new-privileges，UID 1654；`/info`、`/health/live`、`/health/ready` 均 HTTP 200，version 設定值符合預期。測試容器已停止並移除。
- actionlint 1.7.12 通過（未啟用額外 ShellCheck）；各 shell step `bash -n` 通過。
- kubeconform 0.8.0，Kubernetes 1.35.0 strict schema：5 valid、0 invalid/error/skipped。
- 已確認只有 workflow_dispatch trigger，三份相關 Markdown 的本機連結有效；本次修改檔案 whitespace check 通過。
- setup-github-environment.sh：`bash -n`、`--help` 與 mock CLI 測試通過；確認 preview 無寫入、新建六個 variables、重跑保留保護規則且不重複建立角色、OIDC trust 衝突會停止。未對真實 GitHub/Azure 執行套用。
- Azure OIDC、ACR push/pull、AKS rollout、HPA 與 cleanup：待使用者執行，不視為已驗證。

## 官方來源

- [.NET container build](https://learn.microsoft.com/en-us/dotnet/core/docker/build-container)
- [AKS Bicep schema](https://learn.microsoft.com/en-us/azure/templates/microsoft.containerservice/2025-02-01/managedclusters)
- [System node pool requirements](https://learn.microsoft.com/en-us/azure/aks/use-system-pools)
- [AKS Azure RBAC](https://learn.microsoft.com/en-us/azure/aks/entra-id-authorization)
- [GitHub OIDC for Azure](https://docs.github.com/en/actions/how-tos/secure-your-work/security-harden-deployments/oidc-in-azure)

腳本使用的官方文件：[GitHub environment API](https://docs.github.com/en/rest/deployments/environments#create-or-update-an-environment)、[gh variable set](https://cli.github.com/manual/gh_variable_set)、[Azure federated credential CLI](https://learn.microsoft.com/en-us/cli/azure/identity/federated-credential)。
