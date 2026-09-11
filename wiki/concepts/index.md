# Azure Concepts

## Status

Pending。已建立跨認證 taxonomy，尚未建立或驗證個別 canonical pages。

## Concept map

| Group | Concepts | Typical evidence |
| --- | --- | --- |
| Organization and governance | tenant、management group、subscription、resource group、policy、lock、tag | official docs、Resource Graph、policy result |
| Identity and access | Entra identity、service principal、managed identity、RBAC、conditional access | role assignment、token audience、sign-in/audit evidence |
| Networking | VNet、subnet、NSG、route、DNS、private endpoint、load balancing | effective routes/rules、DNS resolution、bounded connectivity check |
| Compute and platform | VM、container、App Service、Functions、AKS | configuration、deployment output、health/runtime check |
| Data and integration | Storage、database、messaging、API integration | data-plane check、identity path、failure behavior |
| Reliability | availability zone、backup、replication、RTO/RPO、recovery | documented SLA/design plus tested recovery evidence |
| Security | shared responsibility、Defender、Key Vault、network isolation、logging | configuration/query、alert or access-denial scenario |
| Delivery and operations | IaC、CI/CD、monitoring、alerting、cost management | validated pipeline, query, alert and cleanup evidence |
| AI workloads | model/service boundary、responsible AI、evaluation、content safety | official docs、deployment/evaluation evidence |

## Learning rule

每個概念回答：它解決什麼問題、位於哪個 Azure boundary、與相近選項的 trade-off、成功時能觀察什麼、設定錯誤或依賴失敗時會發生什麼。只有在 owning page 所述範圍有可追溯證據時才標為 Verified。

