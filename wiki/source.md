# Source Coverage

## Status

初始 Wiki 結構已建立；尚未完成官方 study guides、Microsoft Learn、repository artifacts 或 Azure runtime 的 evidence coverage。

## Coverage status

- **verified**：所述範圍已由有效官方來源、source/test/configuration 或 runtime observation 檢查。
- **partial**：只有明確列出的部分已驗證。
- **pending**：只有 intent 或頁面骨架，缺少目前證據。
- **outdated**：watched source 已變更而尚未重新檢查。

## Coverage ledger

| Slice | Status | Verified revision/date | Canonical pages | Evidence scope | Remaining boundary |
| --- | --- | --- | --- | --- | --- |
| Repository purpose | partial | Initial working tree, 2026-09-09 | [Wiki index](index.md), [Certifications](certifications/index.md) | 六個認證目錄與 Wiki-first governance 已建立 | 尚未盤點各 track 內容與完成條件 |
| Certification scopes | pending | — | [Certifications](certifications/index.md) | 僅記錄 track 與 repository 目錄對應 | 需逐一核對當期官方 study guide 與更新日期 |
| Azure architecture | pending | — | [Architecture](architecture/index.md) | 初始邊界與待建頁面 | 尚無 tenant/subscription/resource inventory 或 design evidence |
| Shared concepts | pending | — | [Concepts](concepts/index.md) | 初始 taxonomy | 尚未建立 canonical concept pages |
| Labs and flows | pending | — | [Labs](labs/index.md), [Flows](flows/index.md) | 安全、可清理與 evidence-first 規則 | 尚無 lab implementation 或 runtime result |
| Learning QA | pending | — | [QA](qa/index.md) | 初始 evidence levels | 尚無 question bank、scenario checks 或 completion result |

## Watched paths

| Slice | Paths to watch |
| --- | --- |
| Certification content | `AZ-*/**`, `AI-*/**`, `wiki/certifications/**` |
| Architecture and shared knowledge | `wiki/architecture/**`, `wiki/concepts/**` |
| Reproducible implementation | `infra/**`, `scripts/**`, `src/**`, `tests/**`, lab-local artifacts |
| Practical learning | `wiki/labs/**`, `wiki/flows/**`, `wiki/qa/**` |
| Knowledge governance | `README.md`, `AGENTS.md`, `wiki/**` |

## Freshness rule

較新的文件日期、repository revision 或成功 deployment 不等於內容已驗證。官方 study guide 或 watched paths 改變後，先重跑 owning page 指定的 checks，再更新 ledger 的日期、revision 與 evidence scope。

## Evidence policy

- 搜尋摘要、課程投影片與社群文章可協助探索，不能單獨成為 durable Azure capability 或 exam-scope 的 canonical 證據。
- IaC validation 或 what-if 證明語法與預期差異，不證明 runtime workload 正常。
- Portal screenshot 可輔助學習，但可重現 CLI/query/test 與 machine-readable output 才是主要 runtime 證據。
- 每項 runtime evidence 應能對應 repository revision、tenant/subscription/resource scope、region、觀察日期、命令與結果；敏感 identifiers 必須遮罩。

