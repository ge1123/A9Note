# 設計與實作發行策略

對應 Issue：[[AZ-400][2.2] 設計與實作發行策略](https://github.com/ge1123/Microsoft-Azure/issues/54)

狀態：待學習。本頁於 2026-09-14 依既有 Issue 整理學習大綱；尚無完成筆記或實作驗證，不代表已重新核對當期考綱。

## 學習大綱

### Release Pipeline 與 Artifact Flow

- 能選擇正確 artifact source
- 能設計 build artifact 至 release environment 的流向
- 能確保 pipeline artifact 可追蹤且不可混淆

### Environments、Checks 與 Approvals

- 能設計 dev、test、staging、production environments
- 能使用 YAML-based environments 設定 checks 與 approvals
- 能分離建置、核准與部署權限

### 部署策略選擇

- 能比較 blue-green、canary、ring、progressive exposure 與 A/B testing
- 能依風險、流量與回復需求選擇策略
- 能定義成功指標與停止條件

### 低停機與漸進式發布

- 能規劃 load balancing、rolling deployment 或 deployment slots
- 能執行 slot swap 或漸進式流量切換
- 能驗證發布期間的可用性

### 相依部署與資料庫變更

- 能可靠安排服務與資源的部署順序
- 能把 database task 納入 deployment pipeline
- 能處理向前／向後相容與 migration 失敗

### Hotfix、回復與部署韌性

- 能設計高優先修正的 hotfix path
- 能定義 rollback／roll-forward 策略
- 能針對部分失敗、重試與中斷設計部署韌性


## 筆記

待補：用自己的話整理理解、適用情境與易混淆之處；內容增加時再拆成主題檔案。

## 待確認與複習

尚未記錄。學習後補上疑問、錯誤原因與可用來自測的問題。

## 來源

以下連結沿用既有 Issue，使用時再確認版本與適用範圍。

- [官方來源 1](https://learn.microsoft.com/en-us/training/paths/az-400-design-implement-release-strategy/)

回到[認證導覽](../README.md)。
