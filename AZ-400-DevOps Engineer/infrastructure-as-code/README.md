# 使用 Azure 與 DSC 管理基礎設施即程式碼

對應 Issue：[[AZ-400][2.4] 使用 Azure 與 DSC 管理基礎設施即程式碼](https://github.com/ge1123/Microsoft-Azure/issues/56)

狀態：待學習。本頁於 2026-09-14 依既有 Issue 整理學習大綱；尚無完成筆記或實作驗證，不代表已重新核對當期考綱。

## 學習大綱

### IaC 與 Configuration Management 策略

- 能比較 imperative 與 declarative configuration
- 理解 idempotency、configuration drift 與 desired state
- 能把 IaC 納入 source control、review、test 與 deployment

### ARM Templates 與 Bicep

- 理解 ARM template 與 Bicep 的結構、參數、模組與相依性
- 能安全引用秘密
- 能以 pipeline 部署並驗證 Bicep 或 ARM template

### Azure CLI 自動化

- 能使用 Azure CLI 查詢與建立資源
- 能撰寫可重跑且具錯誤處理的 CLI script
- 能明確指定 tenant、subscription、resource group 與 region scope

### Azure Automation 與 Runbooks

- 理解 Automation Account、runbook、shared resources 與 webhook
- 能規劃 source control integration
- 能判斷雲端與 hybrid automation 的適用範圍

### Desired State Configuration

- 能說明 DSC components 與 configuration file
- 能偵測並處理 configuration drift
- 能評估 Azure Automation State Configuration、Azure Machine Configuration 或其他方案

### 自助環境與 IaC 驗證

- 能規劃 Azure Deployment Environments 的 on-demand self-deployment
- 能在部署前執行 lint、validate、what-if 或 policy check
- 能記錄成本、權限、環境 scope 與 cleanup


## 筆記

待補：用自己的話整理理解、適用情境與易混淆之處；內容增加時再拆成主題檔案。

## 待確認與複習

尚未記錄。學習後補上疑問、錯誤原因與可用來自測的問題。

## 來源

以下連結沿用既有 Issue，使用時再確認版本與適用範圍。

- [官方來源 1](https://learn.microsoft.com/en-us/training/paths/az-400-manage-infrastructure-as-code-using-azure/)

回到[認證導覽](../README.md)。
