# 使用 Azure Pipelines 實作安全的持續部署

對應 Issue：[[AZ-400][2.3] 使用 Azure Pipelines 實作安全的持續部署](https://github.com/ge1123/Microsoft-Azure/issues/55)

狀態：待學習。本頁於 2026-09-14 依既有 Issue 整理學習大綱；尚無完成筆記或實作驗證，不代表已重新核對當期考綱。

## 學習大綱

### Pipeline 身分與驗證方法

- 能比較 service principal、system-assigned 與 user-assigned managed identity
- 能選擇 GitHub Actions 或 Azure Pipelines 的 Azure 驗證方式
- 能限制身分的權限與作用範圍

### GitHub 與 Azure DevOps 權限治理

- 理解 GitHub App、GITHUB_TOKEN、PAT 與 Azure DevOps service connection
- 能設計 GitHub roles／outside collaborator access
- 能設計 Azure DevOps permissions、security groups、projects 與 teams

### Secretless Authentication 與秘密管理

- 能使用 workload identity federation／OpenID Connect
- 能整合 Azure Key Vault 管理 secrets、keys 與 certificates
- 能規劃秘密輪替與最小權限

### 敏感檔案與資訊洩漏防護

- 能安全使用 Azure Pipelines secure files
- 能避免 secret 出現在 source、logs、artifacts 或輸出
- 能驗證遮罩、權限及暫存檔清理

### App Configuration 與 Feature Flags

- 能將設定與程式碼分離
- 能使用 Azure App Configuration 與 Key Vault reference
- 能以 Feature Manager 實作 feature flag 與動態設定

### 安全持續部署實作

- 能把身分、秘密、approval 與 deployment strategy 串成安全 pipeline
- 能以 container、binary 或 script 完成部署
- 能保留可稽核的部署證據並驗證失敗處理


## 筆記

待補：用自己的話整理理解、適用情境與易混淆之處；內容增加時再拆成主題檔案。

## 待確認與複習

尚未記錄。學習後補上疑問、錯誤原因與可用來自測的問題。

## 來源

以下連結沿用既有 Issue，使用時再確認版本與適用範圍。

- [官方來源 1](https://learn.microsoft.com/en-us/training/paths/az-400-implement-secure-continuous-deployment/)

回到[認證導覽](../README.md)。
