# AZ-900 — Azure Fundamentals

## Status

學習中。2026-09-20 已整理資源管理與身分授權的初步理解；尚無本次學習的 Azure 實作驗證，當期 skills measured 尚待官方 study guide 驗證。

完整筆記、來源與驗證結果記錄於本目錄；Issues 負責目標、進度與討論。其他認證請見 [學習入口](../README.md)。


學習路線：[AZ-900 #1](https://github.com/ge1123/Microsoft-Azure/issues/1)。

## 筆記與實作入口

核心架構與身分安全已加入初步概念筆記，其餘主題仍以待學習大綱為主；不代表已完成整個主題或考綱。

| 主題 | 筆記 | Issue |
| --- | --- | --- |
| 雲端概念 | [README](cloud-concepts/README.md) | [#2](https://github.com/ge1123/Microsoft-Azure/issues/2) |
| Azure 核心架構與運算 | [README](architecture-compute/README.md) | [#3](https://github.com/ge1123/Microsoft-Azure/issues/3) |
| Azure 網路與儲存 | [README](networking-storage/README.md) | [#4](https://github.com/ge1123/Microsoft-Azure/issues/4) |
| Azure 身分識別與安全性 | [README](identity-security/README.md) | [#5](https://github.com/ge1123/Microsoft-Azure/issues/5) |
| Azure 成本、治理與合規 | [README](cost-governance/README.md) | [#6](https://github.com/ge1123/Microsoft-Azure/issues/6) |
| Azure 部署、管理與監視 | [README](management-monitoring/README.md) | [#7](https://github.com/ge1123/Microsoft-Azure/issues/7) |
| Guided Projects 實作 | [README](guided-projects/README.md) | [#8](https://github.com/ge1123/Microsoft-Azure/issues/8) |
| Practice Assessment | [README](exam-preparation/practice-assessment/README.md) | [#9](https://github.com/ge1123/Microsoft-Azure/issues/9) |
| Exam Sandbox 與考前驗收 | [README](exam-preparation/exam-sandbox/README.md) | [#10](https://github.com/ge1123/Microsoft-Azure/issues/10) |

## 我的學習脈絡

記錄日期：2026-09-20。來源：[AZ900 入門核心概念對話](https://chatgpt.com/share/6aaf6d0e-f050-83ee-8668-0c46d8106f3c)。此處記錄對話呈現的理解與學習方式；詳細知識與待確認事項放在各主題。

### 適合我的學習方式

- 從「設計產品從 0 到 1」的需求出發，先問遇到什麼問題，才需要引入下一個概念。
- 一次只聚焦一層。講 Resource 時先認識 AKS、Container Apps、Database 等實例，不一次展開所有管理概念。
- 每一步先用自己的話重述，確認理解後再繼續；最後濃縮成一句話，串起整體關係。

### 這次的理解順序

1. 起點是 AZ-900 該先學什麼，之後選擇先進入 Azure 架構。
2. 從實際提供能力的 Resource，推導為何需要 Resource Group 分組。
3. 再從帳務、權限與配額需求理解 Subscription，從多個 Subscription 的共同治理理解 Management Group。
4. 追問 Tenant 與公司、部門、產品的關係，建立組織與身分邊界的初步類比。
5. 接上 Entra ID、IAM、RBAC，從「是不是三層／是不是 UI」整理成身分、管理領域、授權機制的分工。
6. 用「誰 + 能做什麼 + 在哪裡」理解角色指派。

目前自己的濃縮：

> Azure 資源透過多層管理費用、設定，並透過 IAM 存取／操作 Azure 資源。

整理後的學習摘要：Azure 透過多層架構組織與治理資源，並透過身分與存取管理，控制誰可以對哪些資源執行哪些操作。

詳細筆記：[資源管理的推導與類比限制](architecture-compute/README.md)、[IAM 與角色指派的理解](identity-security/README.md)。後續沿用一次一個概念的節奏；尚未完成的學習項目保留在主題頁，不把對話中的評分視為能力驗證。
