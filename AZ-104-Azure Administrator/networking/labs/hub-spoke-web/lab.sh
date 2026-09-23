#!/usr/bin/env bash
# Local interactive launcher. Azure writes require typed confirmation.
set -euo pipefail
LAB_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if [[ ${1:-} == --help ]]; then
  printf 'Usage: bash "%s/lab.sh"\nInteractive: preflight, what-if, deploy, verify, cleanup. Requires az, python3, curl and an existing SSH public key.\n' "$LAB_DIR"
  exit 0
fi
for dependency in az python3 curl; do
  command -v "$dependency" >/dev/null || { echo "❌ 缺少工具：$dependency" >&2; exit 1; }
done
[[ -t 0 ]] || { echo '❌ 請在互動式 terminal 執行。' >&2; exit 1; }
WORK_DIR="$(mktemp -d "${TMPDIR:-/tmp}/az104-web.XXXXXX")"
trap 'rm -rf -- "$WORK_DIR"' EXIT
umask 077
fail() { echo "❌ 錯誤：$*" >&2; exit 1; }
prompt() {
  local answer
  read -r -p "$2（直接按 Enter 使用預設值：$3；或輸入其他值）: " answer
  printf -v "$1" '%s' "${answer:-$3}"
}
confirm() {
  local answer
  read -r -p "請完整輸入「$1」確認；直接按 Enter 或其他輸入皆取消：" answer
  if [[ "$answer" == "$1" ]]; then
    return 0
  fi
  echo '⏹ 已取消此操作。'
  return 1
}
if ! az account show --output none 2>/dev/null; then
  echo '目前無法取得 Azure 登入資訊；輸入 LOGIN 將啟動 az login，取消則離開腳本。'
  confirm LOGIN || exit 0
  az login --output none
fi
az account list --query '[].{Name:name,SubscriptionId:id,TenantId:tenantId,State:state}' --output table
read -r -p 'Subscription ID（填上表 SubscriptionId，不是 TenantId；必填，直接按 Enter 會結束）: ' SUBSCRIPTION
[[ -n "$SUBSCRIPTION" ]] || fail '必須指定 subscription。'
# Resolve the supplied subscription once; every subsequent command is explicitly scoped.
SUBSCRIPTION="$(az account show --subscription "$SUBSCRIPTION" --query id -o tsv)"
[[ -n "$SUBSCRIPTION" ]] || fail '找不到 subscription。'
az account show --subscription "$SUBSCRIPTION" --query '{Name:name,SubscriptionId:id,TenantId:tenantId,State:state}' -o table
echo '以下設定只指定操作目標；選單 3 預覽並確認後才會建立 Azure 資源。'
echo '建立 lab 請使用新的 RG 名稱；驗收或清理請填既有 lab 的 RG 名稱。'
echo '驗收／清理只適用本腳本建立且具有 lab=hub-spoke-web 標籤的 RG。'
echo '輸入值不需要加引號；若要更換設定，可選 0 離開後重新執行。'
prompt RG 'Lab Resource Group 名稱' 'rg-az104-hub-spoke-web'
[[ "$RG" =~ ^[a-zA-Z0-9_-]+$ ]] && (( ${#RG} <= 90 )) || fail 'RG 請使用 1–90 個英數字、底線或連字號。'
echo '以下區域與 VM 規格用於選單 1–3；只做驗收／清理（4、5）可直接按 Enter。'
prompt LOCATION 'Azure region 區域代碼，例如 eastasia' 'eastasia'
[[ "$LOCATION" =~ ^[a-z0-9]+$ ]] || fail 'Region 格式錯誤。'
prompt VM_SIZE 'VM size 規格，例如 Standard_B2ats_v2' 'Standard_B2ats_v2'
[[ "$VM_SIZE" =~ ^[a-zA-Z0-9_]+$ ]] || fail 'VM size 格式錯誤。'
azs() { az "$@" --subscription "$SUBSCRIPTION"; }
new_group_only() {
  [[ "$(azs group exists -n "$RG")" == false ]] || fail "拒絕部署至既有 RG：$RG。若是先前失敗的 lab，先檢查後清理，或使用新名稱。"
}
preflight() {
  echo "⏳ 正在檢查環境與配額：region=${LOCATION}、size=$VM_SIZE"
  local provider state
  for provider in Microsoft.Compute Microsoft.Network; do
    state="$(azs provider show -n "$provider" --query registrationState -o tsv)"
    [[ "$state" == Registered ]] || fail "${provider} 尚未 Registered；請先在指定 subscription 註冊後重跑。"
  done
  azs vm list-skus -l "$LOCATION" --resource-type virtualMachines --size "$VM_SIZE" --all -o json > "$WORK_DIR/skus.json"
  azs vm list-usage -l "$LOCATION" -o json > "$WORK_DIR/usage.json"
  python3 - "$WORK_DIR" "$VM_SIZE" <<'PY'
import json,sys
from pathlib import Path
p=Path(sys.argv[1]); size=sys.argv[2]
skus=[s for s in json.loads((p/'skus.json').read_text()) if s['name']==size]
if len(skus)!=1:
    sys.exit('❌ 無法唯一確認此區域的 VM SKU，停止部署。')
s=skus[0]
if s.get('restrictions'):
    sys.exit('❌ SKU 有限制，請確認限制或選擇其他規格／region。')
caps={c['name']:c['value'] for c in s['capabilities']}
def nonnegative_int(value, field):
    if isinstance(value, bool) or not isinstance(value, (int, str)):
        sys.exit(f'❌ {field} 不是有效的非負整數，停止檢查；未建立資源。')
    try:
        number = int(value)
    except ValueError:
        sys.exit(f'❌ {field} 不是有效的非負整數，停止檢查；未建立資源。')
    if number < 0:
        sys.exit(f'❌ {field} 不可為負數，停止檢查；未建立資源。')
    return number
cores=nonnegative_int(caps.get('vCPUs'), 'SKU vCPUs')
usage={u['name']['value'].lower():u for u in json.loads((p/'usage.json').read_text())}
for name in (s['family'].lower(),'cores'):
    u=usage.get(name)
    if u is None: sys.exit('❌ 缺少 family 或 regional vCPU quota 資料，停止部署。')
    limit=nonnegative_int(u.get('limit'), f'{name} limit')
    current=nonnegative_int(u.get('currentValue'), f'{name} currentValue')
    free=limit-current
    print(f'{name}: 可用 {free}，需要 {cores} vCPUs')
    if free < cores: sys.exit('❌ 配額不足；本腳本不自動申請配額。')
print('✅ 環境與配額檢查通過：provider 已註冊、SKU 無列出限制，family／regional vCPU 配額足夠。')
print('ℹ️ 此結果不保證部署當下容量、Policy 或權限一定允許。')
PY
}
prepare() {
  new_group_only
  preflight
  echo '公鑰用於設定 VM 登入身分；此 lab 不開放 Internet SSH。請輸入檔案路徑，不是公鑰內容。'
  prompt KEY_PATH '既有 SSH 公鑰的絕對路徑（.pub 檔，需已存在；不要填私鑰）' "$HOME/.ssh/id_ed25519.pub"
  case "$KEY_PATH" in
    '~/'*) KEY_PATH="$HOME/${KEY_PATH#\~/}" ;;
  esac
  [[ "$KEY_PATH" == /* ]] || fail '請填完整絕對路徑或 ~/ 開頭的路徑，不需加引號。'
  [[ -f "$KEY_PATH" ]] || fail '找不到公鑰。可先自行執行 ssh-keygen。'
  python3 - "$KEY_PATH" "$WORK_DIR/parameters.json" "$RG" "$LOCATION" "$VM_SIZE" <<'PY'
import json,sys
from pathlib import Path
key=Path(sys.argv[1]).read_text().strip()
if '\n' in key or not key.startswith(('ssh-ed25519 ', 'ssh-rsa ')):
    sys.exit('❌ 只接受單行 Ed25519 或 RSA SSH 公鑰。')
values=dict(rgName=sys.argv[3],location=sys.argv[4],vmSize=sys.argv[5],sshPublicKey=key)
Path(sys.argv[2]).write_text(json.dumps({'$schema':'https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#','contentVersion':'1.0.0.0','parameters':{k:{'value':v} for k,v in values.items()}}))
PY
}
preview() {
  echo '⏳ 正在執行 What-if；只預覽預計變更，不會建立 lab 資源；完成後不需回答 yes/no。'
  azs deployment sub what-if --location "$LOCATION" --template-file "$LAB_DIR/main.bicep" --parameters "@$WORK_DIR/parameters.json" || fail '部署預覽失敗，請查看上方錯誤。'
  echo '✅ 部署預覽完成：尚未建立 lab 資源。'
}
owned_group() {
  [[ "$(azs group show -n "$RG" --query tags.lab -o tsv)" == hub-spoke-web ]] || fail 'RG 缺少 lab=hub-spoke-web 標籤，拒絕操作。'
}
verify() {
  echo '⏳ 正在驗收：檢查雙向 peering 與 Load Balancer HTTP 回應。'
  owned_group
  local vnet state ip body attempt
  for vnet in hub spoke; do
    state="$(azs network vnet peering show -g "$RG" --vnet-name "vnet-issue16-$vnet" -n "peer-$vnet-to-$([[ "$vnet" == hub ]] && echo spoke || echo hub)" --query peeringState -o tsv)"
    [[ "$state" == Connected ]] || fail "$vnet peering 尚未 Connected。"
  done
  ip="$(azs network public-ip show -g "$RG" -n pip-issue16-lb --query ipAddress -o tsv)"
  [[ "$ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]] || fail '尚未取得 public IPv4。'
  echo '⏳ 等待 nginx 與 LB probe 就緒（最多 30 次，每次間隔 10 秒）…'
  for ((attempt=1; attempt<=30; attempt++)); do
    if body="$(curl --noproxy '*' --fail --silent --show-error --connect-timeout 5 --max-time 10 "http://$ip/" 2>/dev/null)" && [[ "$body" == vm-web01 ]]; then
      printf '\n✅ 驗收成功：2 項檢查全部通過。\n'
      echo '  ✓ Hub／Spoke 雙向 peering 都是 Connected。'
      echo '  ✓ 本機透過 Load Balancer HTTP 收到 vm-web01。'
      echo 'ℹ️ 範圍限制：尚未驗證 peering VM 流量、UDR 丟棄行為或 Storage firewall。'
      return
    fi
    sleep 10
  done
  fail 'HTTP 驗收逾時。部署不等於驗收成功；請檢查 cloud-init、LB probe、NSG 與 outbound rule。資源仍存在並可能計費。'
}
while true; do
  printf '\n目前目標：\nSubscription ID: %s\nResource Group: %s\nRegion: %s\nVM size: %s\n1) 唯讀環境與配額檢查\n2) What-if 預覽（新 RG）\n3) 建立完整 lab + HTTP 驗收（新 RG）\n4) 驗收既有 lab\n5) 刪除 lab RG 及其中全部資源\n0) 離開\n' "$SUBSCRIPTION" "$RG" "$LOCATION" "$VM_SIZE"
  echo '第一次使用可先選 1 檢查，選 2 只看預覽，選 3 才會進入建立確認。'
  read -r -p '請輸入選單編號 0–5（無預設；直接按 Enter 會重新顯示選單）: ' choice
  case "$choice" in
    1) preflight ;;
    2) prepare; preview ;;
    3)
      prepare
      preview
      echo "即將在 $LOCATION 建立 RG $RG、網路、Standard Public IP/LB、1 台 $VM_SIZE VM 與 OS disk。"
      echo '⚠️ VM、disk、Public IP、LB、peering／資料傳輸可能計費；停止 VM 不會清除全部費用。'
      echo '公開 TCP 80 提供測試頁面；沒有公開 SSH。清理方式：選單 5 刪除整個 lab RG。'
      read -r -p '是否開始部署？輸入 y 確認，直接按 Enter 取消 [y/N]: ' deploy_answer
      case "$deploy_answer" in
        y|Y) ;;
        *) echo '⏹ 已取消部署。'; continue ;;
      esac
      new_group_only
      echo '⏳ 正在部署 Azure 資源；可能需要數分鐘。'
      if ! azs deployment sub create --name "az104-web-$(date -u +%Y%m%dT%H%M%SZ)" --location "$LOCATION" --template-file "$LAB_DIR/main.bicep" --parameters "@$WORK_DIR/parameters.json" --output none; then
        echo '❌ 部署失敗，可能留下計費資源。請重跑選單 5 檢查並清理；不會自動刪除。' >&2
        exit 1
      fi
      echo '✅ Azure 資源部署完成；接下來執行功能驗收。'
      verify
      ;;
    4) verify ;;
    5)
      owned_group
      azs resource list -g "$RG" --query '[].{name:name,type:type,location:location}' -o table
      echo "⚠️ 將永久刪除 subscription $SUBSCRIPTION 的 RG $RG，以及其中所有資源（包含額外放入的資源）。"
      read -r -p '是否刪除上述 RG 及其中全部資源？輸入 y 確認，直接按 Enter 取消 [y/N]: ' delete_answer
      case "$delete_answer" in
        y|Y) ;;
        *) echo '⏹ 已取消清理。'; continue ;;
      esac
      echo '⏳ 正在刪除 RG 並等待 Azure 完成；可能需要數分鐘。'
      azs group delete -n "$RG" --yes || fail '清理失敗，請查看上方錯誤（例如 Resource lock）；未確認 RG 已刪除。'
      [[ "$(azs group exists -n "$RG")" == false ]] || fail 'RG 尚未刪除。'
      echo '✅ 清理完成：已確認 RG 不存在。本機既有 SSH key 保留。'
      ;;
    '') continue ;;
    0) echo 'ℹ️ 已離開；既有 Azure 資源會保留。'; exit 0 ;;
    *) echo '⚠️ 無效選項，請輸入 0–5。' ;;
  esac
done
