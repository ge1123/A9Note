# Microsoft Azure Repository Guide

## Purpose

本 repository 用來累積 Azure 認證學習材料、可重現 labs 與驗證證據。目前涵蓋 AZ-900、AZ-104、AI-200、AZ-500、AZ-305 與 AZ-400；內容以實際 Azure 行為與 Microsoft 官方來源為準，不把考試印象、規劃或推測寫成已驗證事實。

## Wiki-first workflow

每個 repository task 依序進行：

1. 先讀 [wiki/index.md](wiki/index.md)。
2. 只開啟與任務直接相關的 canonical Wiki pages 與認證目錄。
3. 檢查頁面 Status 與 [wiki/source.md](wiki/source.md) 的 evidence coverage。
4. Wiki 已足夠回答唯讀問題時，避免無關的全 repository 掃描。
5. 需要確認目前 Azure 行為時，再檢查 IaC、scripts、tests、Azure CLI 輸出或 Portal evidence。
6. 明確區分 Verified fact、Reasonable inference 與 Open question。

完整維護規則見 [wiki/AGENTS.md](wiki/AGENTS.md)。

## Azure boundary

- 本機 repository、CLI 與編輯環境，和 Azure tenant、subscription、resource group、region 及 deployed resources 必須分開描述。
- 命令需標示執行位置與必要登入/權限前提；不得假設目前 subscription、tenant 或 region。
- 所有 resource name、subscription ID、tenant ID、principal ID、public endpoint 與成本影響都視為需要確認的環境資料。
- 建立或修改 Azure 資源前，先說明 scope、預期影響、成本與 cleanup；唯讀 inventory 不代表有修改授權。
- 不提交 secret、token、password、certificate private key、完整 connection string 或未遮罩的環境輸出。

## Change and verification rules

- 編輯前確認目標檔案與 working tree，保留使用者既有變更。
- durable architecture、security boundary、identity path、deployment flow 或 certification mapping 改變時，同步更新 canonical Wiki page、`wiki/source.md`，必要時更新 `wiki/log.md`。
- 文件變更要檢查 Markdown links；IaC 或 script 變更先執行最窄的靜態驗證，再執行使用者授權範圍內的 plan、what-if 或 runtime checks。
- 不以 deployment succeeded 代表功能、安全性、復原能力或考綱能力已驗證；證據必須對應 revision、environment scope、command/result 與觀察日期。

