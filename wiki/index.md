# Microsoft Azure Wiki

## Status

Wiki-first 骨架已初始化。六個認證內容邊界已建立，但 exam skills mapping、服務知識、labs 與 Azure runtime evidence 仍為 Pending。

## Entry points

| Area | Purpose | Entry |
| --- | --- | --- |
| Architecture | tenant、subscription、identity、network、region 與 workload 邊界 | [architecture/index.md](architecture/index.md) |
| Certifications | 六個認證的 scope、重疊與內容位置 | [certifications/index.md](certifications/index.md) |
| Concepts | 跨服務與跨認證的 canonical 概念 | [concepts/index.md](concepts/index.md) |
| Labs | 可重現、可清理、可驗證的實作切片 | [labs/index.md](labs/index.md) |
| Flows | provisioning、deployment、operations 與 incident 流程 | [flows/index.md](flows/index.md) |
| QA | 知識與 lab 必須滿足的驗證門檻 | [qa/index.md](qa/index.md) |
| Problems | 已診斷問題、原因、修正與驗證狀態 | [problems/index.md](problems/index.md) |
| Source coverage | Wiki 知識的來源、revision 與證據範圍 | [source.md](source.md) |
| Log | material knowledge 與架構變更 | [log.md](log.md) |
| Templates | 新頁面的起始格式 | [templates/](templates/) |

## Knowledge map

```text
Certification intent
├─ certifications: exam scope 與 track ownership
├─ concepts: 跨認證共通知識
└─ QA: recall、explanation 與 hands-on evidence

Azure boundary
Local tools/IaC → tenant → subscription → resource group → Azure resource
                    identity, RBAC, policy, network, region and cost boundaries

Practical evidence
├─ labs: 一次改變一個主要變因
├─ flows: 跨工具與服務的操作路徑
├─ source: 哪些敘述由什麼來源或 runtime evidence 支持
└─ problems: 已發生問題與可重現解法
```

## Lookup strategy

- 想定位 Azure governance、identity、network 或 workload 邊界：讀 [Architecture](architecture/index.md)。
- 想知道內容屬於哪張認證：讀 [Certifications](certifications/index.md)。
- 想理解跨服務名詞與 trade-off：讀 [Concepts](concepts/index.md)。
- 想建立或重現 Azure 資源：先讀 [Labs](labs/index.md) 與 [Flows](flows/index.md)。
- 想判斷敘述或 lab 是否可信：讀 [QA](qa/index.md) 與 [Source coverage](source.md)。
- 遇到錯誤、不一致或文件與 runtime 衝突：先找 [Problems](problems/index.md)。

## Authority

- Microsoft 官方 study guide 定義當期 exam skills measured。
- Microsoft Learn 與產品文件定義 documented capability 和限制。
- Repository source/IaC/tests 定義本專案 intent。
- 帶有日期、environment scope 與可重現步驟的 runtime observation 證明特定環境行為。
- Wiki 摘要與連結證據，但不把考綱、規劃或部署成功描述成完整能力已驗證。

