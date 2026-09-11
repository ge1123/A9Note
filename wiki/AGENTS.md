# Wiki Maintenance Guide

本 Wiki 是 Azure 學習知識入口、認證範圍索引與證據 ledger。它不取代 Microsoft 官方文件、exam study guide、IaC/source、tests、Azure CLI/Resource Graph 輸出或 Azure runtime state。

## Workflow

1. 從 [index.md](index.md) 找到任務所屬區域。
2. 讀取直接相關的 canonical pages 與認證目錄。
3. 先檢查 page Status 與 [source.md](source.md)，再決定是否需要檢查官方來源或實作。
4. 將敘述分類為 Verified fact、Reasonable inference 或 Open question。
5. durable behavior、security boundary、service capability、exam mapping 或 deployment flow 改變時，更新 owning page 與 source coverage。

## Evidence roles

- 使用者需求與 [README.md](../README.md) 定義專案目的及範圍。
- Microsoft Learn、產品文件與正式 study guides 證明官方定義、能力與考綱範圍。
- IaC、scripts 與 tests 證明 repository intent 和可自動驗證行為。
- Azure CLI、Resource Graph、deployment output、logs 與 bounded runtime checks 證明特定環境的實際狀態。
- Wiki 提供導航、摘要、證據連結與已知缺口。

## Page status

- **Proposed**：設計或學習提案，尚未由來源或實作驗證。
- **Pending**：已知需要涵蓋，但缺少足夠證據。
- **Partial**：只有頁面明確描述的範圍已驗證。
- **Verified**：頁面明確描述的範圍已有具體、可追溯證據。
- **Outdated**：監看來源、考綱或實作已變更，頁面尚未重驗。

Status 不會自動讓頁面中的每句話成為 verified fact。

## Maintenance rules

- 每項事實只放在最合適的 canonical page，其他頁面以連結引用。
- `index.md` 僅保留導航、lookup strategy 與短狀態摘要。
- `source.md` 是來源日期、revision、evidence scope 與 watched paths 的 ledger，不是逐字筆記。
- `log.md` 只記錄 material architecture、certification mapping、evidence status 或 known-gap 變更。
- 新增頁面時，同步更新所在目錄的 index 與必要 cross-links。
- 官方文件、repository 與 runtime evidence 衝突時，保留 conflict note，分開記錄 documented behavior、observed behavior 與 target design。
- 不記錄 secret、token、password、private key、完整 connection string 或未遮罩的 identifiers。

