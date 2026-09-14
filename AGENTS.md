# Microsoft Azure Repository Guide

## Purpose

本 repository 用來累積 Azure 認證學習材料、可重現 labs 與驗證證據。目前涵蓋 AZ-900、AZ-104、AI-200、AZ-500、AZ-305 與 AZ-400；內容以實際 Azure 行為與 Microsoft 官方來源為準，不把考試印象、規劃或推測寫成已驗證事實。

## 輕量導覽

- 需要定位內容時，從 [README.md](README.md) 選擇認證目錄。
- 只讀取與任務相關的筆記、labs 或 scripts，避免無關的全 repository 掃描。
- 來源、驗證結果與待確認事項直接記錄在相關文件中；需要確認目前 Azure 行為時，再查官方文件或實作證據。

## 筆記與 Issues 分工

- Repository 保存完整筆記與可重現實作；Issues 保存學習目標、完成條件、進度、問題討論及筆記／commit 連結。
- 主題使用 `<認證目錄>/<主題>/README.md`；主題名保持穩定，不使用 Issue 編號作為資料夾名稱。
- 筆記就近記錄自己的理解、適用情境、比較、易混淆處與官方來源；內容增加時才拆檔，不為每個 objective 建立空檔。
- Labs 放在相關主題的 `labs/<lab-name>/`，記錄執行前提、位置、日期、revision、環境範圍、操作、預期／實際結果與 cleanup。
- 認證 README 連到主題文件與相關 Issues；主題文件連回 Issue。跨認證共用概念以相對連結引用，避免複製整份筆記。
- 只有來源規劃或骨架時標示待學習／待驗證；區分已驗證事實、合理推論與待確認事項。
- 不預先建立模板留言；進度與討論寫在 Issue，整理後的知識寫回 repo。需要修改 GitHub 內容時遵循使用者授權範圍。
- 學習規劃中的完成條件與實際學習成果分開；父層只做導航與彙總，詳細證據放在主題或 Lab。

## Azure boundary

- 本機 repository、CLI 與編輯環境，和 Azure tenant、subscription、resource group、region 及 deployed resources 必須分開描述。
- 命令需標示執行位置與必要登入/權限前提；不得假設目前 subscription、tenant 或 region。
- 所有 resource name、subscription ID、tenant ID、principal ID、public endpoint 與成本影響都視為需要確認的環境資料。
- 建立或修改 Azure 資源前，先說明 scope、預期影響、成本與 cleanup；唯讀 inventory 不代表有修改授權。
- 不提交 secret、token、password、certificate private key、完整 connection string 或未遮罩的環境輸出。

## Change and verification rules

- 編輯前確認目標檔案與 working tree，保留使用者既有變更。
- 內容改變時，更新相關認證目錄中的文件；新增學習入口時，再更新對應 README。
- 文件變更要檢查 Markdown links；IaC 或 script 變更先執行最窄的靜態驗證，再執行使用者授權範圍內的 plan、what-if 或 runtime checks。
- 不以 deployment succeeded 代表功能、安全性、復原能力或考綱能力已驗證；證據必須對應 revision、environment scope、command/result 與觀察日期。

