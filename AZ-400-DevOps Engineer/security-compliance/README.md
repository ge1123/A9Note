# 實作安全並驗證程式碼庫合規性

對應 Issue：[[AZ-400][3.1] 實作安全並驗證程式碼庫合規性](https://github.com/ge1123/Microsoft-Azure/issues/57)

狀態：待學習。本頁於 2026-09-14 依既有 Issue 整理學習大綱；尚無完成筆記或實作驗證，不代表已重新核對當期考綱。

## 學習大綱

### DevSecOps 與 Threat Modeling

- 能將安全活動嵌入 plan、code、build、test、deploy 與 operate
- 能辨識常見威脅與攻擊面
- 能以 threat modeling 決定控制與驗證方式

### 開源軟體與授權治理

- 理解常見 OSS license 對使用與散布的影響
- 能建立核准、盤點與例外流程
- 能在 pipeline 中檢查 license compliance

### 安全與合規掃描策略

- 能設計 dependency、code、secret、license 與 IaC scanning
- 能定義掃描時機、嚴重度門檻與阻擋規則
- 能將發現連結至負責人與修復期限

### GitHub Advanced Security、CodeQL 與 Dependabot

- 能設定 code scanning／CodeQL
- 能使用 Dependabot alerts 與自動更新
- 能處理 secret scanning 或 push protection 發現

### Container 與供應鏈安全

- 能自動掃描 container image
- 能在 container 中執行 CodeQL 或相關分析
- 能驗證 image、base image 與 package 來源

### Defender for Cloud 與合規整合

- 能設定 Defender for Cloud DevOps Security
- 能整合 GitHub Advanced Security 與 Defender for Cloud
- 能使用 Azure Policy、resource locks 或治理訊號支援合規


## 筆記

待補：用自己的話整理理解、適用情境與易混淆之處；內容增加時再拆成主題檔案。

## 待確認與複習

尚未記錄。學習後補上疑問、錯誤原因與可用來自測的問題。

## 來源

以下連結沿用既有 Issue，使用時再確認版本與適用範圍。

- [官方來源 1](https://learn.microsoft.com/en-us/training/paths/az-400-implement-security-validate-code-bases-compliance/)

回到[認證導覽](../README.md)。
