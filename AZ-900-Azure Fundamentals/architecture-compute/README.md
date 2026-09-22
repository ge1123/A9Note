# Azure 核心架構與運算

對應 Issue：[[AZ-900][1.2] Azure 核心架構與運算](https://github.com/ge1123/Microsoft-Azure/issues/3)

狀態：學習中。2026-09-20 補入資源管理的初步理解，並核對下列 ARM 官方文件；尚無 Azure 實作驗證，其他大綱仍待學習，未重新核對當期考綱。

## 學習大綱

- 說明 Azure 區域、區域配對、主權區域及可用性區域
- 說明資源、資源群組、訂用帳戶及管理群組的關係
- 依需求比較 Virtual Machines、VM Scale Sets、App Service、容器及 Azure Functions
- 說明虛擬桌面及應用程式主機選項
- 辨識高可用性、擴展及無伺服器情境適合的運算服務
- 說明 Azure 資料中心的用途及其與區域的關係
- 說明 Availability Sets 的用途
- 說明建立 VM 所需的運算、儲存及網路資源

## 筆記

### 2026-09-20：從產品需求理解資源管理

採用的推導順序是 Resource → Resource Group → Subscription → Management Group，再追問 Tenant 的用途。這是理解設計動機的順序，不是 Microsoft 產品發展史，也不是實際建立資源的操作順序。

| 當時追問的問題 | 目前的理解 |
| --- | --- |
| 要跑 API、存資料，先需要什麼？ | 先認識實際資源，例如 Container App、AKS 叢集、SQL Database、Storage Account、VNet、Key Vault。 |
| 一個系統有 API、DB 等資源，怎麼一起管理？ | 用 Resource Group 將相關資源分組；重點是管理與生命週期，不是只把同類型資源放一起。 |
| 不同環境需要分開帳務、權限與配額，怎麼切？ | 對話中以 Subscription 作為理解這些邊界的入口；各服務配額的實際範圍仍需另查。 |
| Subscription 變多，如何共同治理？ | 用 Management Group 對多個 Subscription 分組，套用共同治理設定。 |
| 這些人與應用程式的身分屬於哪裡？ | 對話用 Tenant ≈ 公司／組織作為初步類比，接到身分管理主題。 |

曾使用「公司 → 產品 → 環境 → 系統 → 資源」協助理解。這是情境範例，不是強制對應；Management Group 不必按產品劃分，Resource Group 也不必等於一整個系統。

### 官方文件核對與類比限制

2026-09-20 核對 [Azure Resource Manager overview](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview)：

- 文件列出的四層管理範圍是 Management Group → Subscription → Resource Group → Resource。對話把 Tenant 畫在上方是概念示意，不應直接背成五個相同性質的管理範圍。
- Resource Group 用來管理相關資源，應考慮共同生命週期；相互連接的資源可以分屬不同 Resource Group。
- 「資源多了才需要分組」是設計動機的比喻。建立一般 RG 範圍的資源，即使只有一個，也需要所屬 RG；另有可部署在 Subscription、Management Group 或 Tenant 範圍的特定資源類型。

身分與授權如何接上這些範圍，見[身分識別與安全性](../identity-security/README.md)。

## 待確認與複習

- 待深化：Tenant 與 Subscription 的關聯，及為何不能把「一家公司一個 Tenant」當成必然規則。
- 待確認：帳務結構與各服務配額的實際範圍；目前只建立概念入口。
- 待自測：為什麼 API 與 DB 可能放同一個 RG，也可能分開？
- 區域、可用性與運算服務比較尚未在這次對話深入學習。

## 來源

- [學習對話：AZ900 入門核心概念](https://chatgpt.com/share/6aaf6d0e-f050-83ee-8668-0c46d8106f3c)（理解脈絡，不作為官方事實來源）
- [Azure Resource Manager overview](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview)（2026-09-20 核對管理範圍與 RG 原則）

以下連結沿用既有 Issue，使用時再確認版本與適用範圍。

- [官方來源 1](https://learn.microsoft.com/training/paths/azure-fundamentals-describe-azure-architecture-services/)

回到[認證導覽](../README.md)。
