# Hub／Spoke + Web Load Balancer 互動式 lab

對應 [Issue #16](https://github.com/ge1123/Microsoft-Azure/issues/16)、[網路主題 #23](https://github.com/ge1123/Microsoft-Azure/issues/23)。原始流程見 [tmp.md](../../../tmp.md)，回到[網路筆記](../../README.md)。

狀態：2026-09-22 建立自動化版本，已完成本機靜態與模擬流程驗證；尚未以此 revision 部署 Azure。不沿用原始手動流程的截圖作為此版本成功證據。

## 執行位置與前提

在自己的 macOS／Linux terminal 執行，需 Bash 3.2+、Azure CLI、Bicep CLI（`az bicep install`）、Python 3、curl，以及既有 RSA／Ed25519 SSH 公鑰。沒有公鑰時可自行執行 `ssh-keygen -t ed25519`，妥善保存私鑰；腳本只讀取公鑰，不建立或刪除 SSH key。

需能登入目標 tenant，並在明確選定的 subscription 擁有建立 RG、部署與刪除 lab 資源的權限（例如適當 scope 的 Contributor）。Microsoft.Compute／Microsoft.Network 必須已註冊。Region、VM size、SKU 限制、family quota 與 regional vCPU quota 必須適用；預設值是可修改的 lab 範例，不代表已確認目前環境。

從 repository 根目錄執行：

```bash
bash 'AZ-104-Azure Administrator/networking/labs/hub-spoke-web/lab.sh'
```

先列出可用帳戶，從 `SubscriptionId` 欄複製目標訂用帳戶 ID（不是 `TenantId`）；此欄必填，直接按 Enter 會結束。所有 Azure 命令都明確傳入 subscription，不修改全域預設 subscription。

RG、region、VM size 與 SSH 公鑰路徑的提示均明列預設值：直接按 Enter 採用預設，也可輸入其他值。RG 是操作目標；建立時填新名稱，驗收／清理時填既有 lab 名稱。填寫設定不會建立 Azure 資源，選單 3 預覽並確認後才會建立。公鑰路徑需指向已存在的 `.pub` 檔，支援絕對路徑或 `~/` 開頭；輸入路徑而非公鑰內容，所有輸入均不需加引號。選單 4、5 不使用輸入的 region／VM size，可接受預設值。驗收／清理只接受帶有 `lab=hub-spoke-web` 標籤的 RG，不適用任意手動 lab。若要更換設定，選 0 離開後重新執行；離開不會刪除既有資源。

選單沒有預設操作，直接按 Enter 會重新顯示選單。部署與刪除確認輸入 `y` 或 `Y` 才繼續，直接按 Enter 或其他輸入皆取消。登入確認仍需完整輸入提示文字；直接按 Enter 或其他輸入皆取消該操作。

操作訊息以 `⏳` 表示進行中、`✅` 表示該步驟成功、`❌` 表示失敗、`⏹` 表示取消、`⚠️` 表示注意事項、`ℹ️` 表示補充說明。部署完成與功能驗收成功分開顯示；預覽完成不表示已建立資源。

| 選單 | 行為 |
| --- | --- |
| 1 | 唯讀確認 provider、SKU 限制與兩種 vCPU 配額 |
| 2 | 檢查新 RG、配額、公鑰，執行 subscription deployment what-if |
| 3 | 同上，預覽後輸入 `y` 確認才建立資源，接著驗收 HTTP |
| 4 | 驗收帶有本 lab 標籤的既有 RG，不需公鑰或剩餘 quota |
| 5 | 列出 RG 內資源，輸入 `y` 確認後刪除整個 RG，確認不存在 |
| 0 | 離開 |

發生錯誤會停止並保留 Azure 資源供排查；可重新執行並指定相同 subscription／RG，選 4 或 5。部署入口刻意拒絕任何既有 RG，包括本 lab，以保留原始「避免修改同名資源」要求；此啟動器不提供就地更新。名稱檢查並非 Azure 原子鎖，請勿與其他部署同時使用同一 RG 名稱。

## 範圍、成本與 cleanup

[main.bicep](main.bicep) 在 subscription scope 建立 RG，呼叫 [resources.bicep](resources.bicep) 建立 Hub／Spoke、三個 subnet、雙向 peering、NSG／ASG、UDR、Storage service endpoint、Standard Public IP／LB、HTTP probe／rule、outbound rule、NIC、一台 Ubuntu VM 與 Standard_LRS OS disk。[cloud-init.yaml](cloud-init.yaml) 安裝 nginx，首頁回傳 `vm-web01`。

Web subnet 禁用 default outbound access，VM 透過 LB outbound rule 出網下載套件；HTTP 80 對 Internet 開放，沒有公開 SSH 路徑。Cloud-init 的安裝依賴套件來源可達。VM image 使用 `latest`，重建不保證相同 OS image；需要嚴格重現時應鎖定經驗證的版本。

VM、OS disk、Standard Public IP、LB、peering 與資料傳輸可能計費。停止 VM 不等於清除所有費用。選 5 將刪除整個 RG，包含後來加入的資源；請保持專用 RG。Lab tag 是避免誤操作的檢查，並非所有權／權限證明。Subscription deployment history 不隨 RG 刪除，本機既有 SSH key 也不刪除。

不建立 Storage Account、Private Endpoint、NAT Gateway、Bastion 或額外 app／spoke VM。Service endpoint 不等於設定 Storage firewall。

## 驗收與證據

預期選 4 或部署後：雙向 peering 都是 `Connected`，本機經 Public IP → LB → NIC → VM 的 HTTP 回應為 `vm-web01`。HTTP 最多嘗試 30 次，每次 curl 最長 10 秒並間隔 10 秒。逾時不會自動刪除資源。

此驗收不涵蓋跨 VNet VM 流量、UDR 丟棄封包、Storage 存取限制，也不等於全面安全性或可用性驗證。Deployment 成功不代表 cloud-init 完成，HTTP probe 就緒可能稍晚。

本機已執行：`bash -n lab.sh`、Bicep build、模擬 CLI 的拒絕／取消路徑測試與文件相對連結檢查。Azure scope／實際部署結果：未執行、待驗證。首次實際執行後，請在此補上觀察日期、`git rev-parse HEAD` 與工作樹差異、遮罩後 environment scope、命令／結果和 cleanup 結果。不要提交完整環境輸出、endpoint、私鑰或 token。

## 官方來源

- [Bicep subscription deployment](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deploy-to-subscription)
- [Bicep resource dependencies](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/resource-dependencies)
- [Load Balancer resource schema](https://learn.microsoft.com/en-us/azure/templates/microsoft.network/loadbalancers)
- [Subnet resource schema](https://learn.microsoft.com/en-us/azure/templates/microsoft.network/virtualnetworks/subnets)
- [VM custom data／cloud-init completion semantics](https://learn.microsoft.com/en-us/azure/virtual-machines/custom-data)
