# Azure 身分識別與安全性

對應 Issue：[[AZ-900][2.2] Azure 身分識別與安全性](https://github.com/ge1123/Microsoft-Azure/issues/5)

狀態：學習中。2026-09-20 補入 IAM 與角色指派的初步理解，並核對下列 Azure RBAC 官方文件；尚無 Azure 實作驗證，其他大綱仍待學習，未重新核對當期考綱。

## 學習大綱

- 說明 Microsoft Entra ID 與 Microsoft Entra Domain Services 的用途
- 比較單一登入、多重要素驗證及無密碼驗證
- 說明外部身分識別及條件式存取
- 說明 Azure RBAC 的用途、角色指派及最小權限原則
- 說明 Zero Trust 與多層防禦模型
- 說明 Azure 加密、Key Vault 及 Microsoft Defender for Cloud 的用途

## 筆記

### 2026-09-20：從資源管理接到身分與授權

前置理解：[資源管理範圍](../architecture-compute/README.md)。這次想回答的是：知道資源放在哪裡後，如何決定誰可以操作？

理解的轉折：

1. 最初嘗試把 Entra ID、IAM、RBAC 排成另一套上下層關係。
2. 接著用「為 email／application 建立 Entra ID，再賦予 role」描述流程。
3. 再追問 IAM 是否只是 UI，或是包含 Identity 與 Access 的整體系統。
4. 最後採用下表作為入門分工，而不是三層樹狀架構。

| 名詞 | 目前使用的入門理解 |
| --- | --- |
| IAM | Identity and Access Management，身分與存取管理的整體領域。 |
| Microsoft Entra ID | 理解「誰」的身分服務；建立的是服務中的身分物件，不是為每個 email 建立一套 Entra ID。 |
| Azure RBAC | 透過角色指派，管理誰能在什麼範圍做哪些操作。 |
| Access control (IAM) | 對話中提到的 Azure Portal 權限管理入口；實際操作尚待練習。 |

### 角色指派的核心模型

2026-09-20 核對 [Azure RBAC overview](https://learn.microsoft.com/en-us/azure/role-based-access-control/overview)，角色指派包含三個要素：

```text
Security principal + Role definition + Scope
誰                   能做什麼          在哪裡
```

可授權的對象包括 User、Group、Service Principal、Managed Identity；目前先認識名稱，尚未深入它們的差異。

學習用假設範例：Alice + Contributor + rg-order-dev，表示在該 RG 範圍授予 Alice 這個角色所定義的權限。這些名稱只是範例，沒有對應已確認的 Azure 環境或實際角色指派。

「Identity + Role + Scope = Permission」適合協助記憶，但精確說法是組成一筆角色指派；不能直接當成完整有效權限的計算式。官方文件還說明多筆角色指派、deny assignment 與條件等會影響授權判斷。

## 待確認與複習

- 下一個可接續的主題：一次只拆一種身分，先理解 User，再延伸 Group、Service Principal 與 Managed Identity。
- 待深化：Tenant、Entra ID 與身分物件的關係，以及 Application 與 Service Principal 的差異。
- 待學習：驗證身分與授權的差別、Azure 角色與 Entra 角色的差別、管理資源與讀取資源內資料的權限差別。
- 待自測：同一個人，在兩個不同 RG 可以有不同角色嗎？如何用三個要素描述？
- 尚未操作 Portal／CLI 角色指派，也尚未驗證允許、拒絕或繼承行為。

## 來源

- [學習對話：AZ900 入門核心概念](https://chatgpt.com/share/6aaf6d0e-f050-83ee-8668-0c46d8106f3c)（理解脈絡，不作為官方事實來源）
- [Azure RBAC overview](https://learn.microsoft.com/en-us/azure/role-based-access-control/overview)（2026-09-20 核對角色指派與授權判斷）

以下連結沿用既有 Issue，使用時再確認版本與適用範圍。

- [官方來源 1](https://learn.microsoft.com/training/paths/azure-fundamentals-describe-azure-architecture-services/)

回到[認證導覽](../README.md)。
