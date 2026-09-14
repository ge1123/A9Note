# 使用 Azure Pipelines 與 GitHub Actions 實作 CI

對應 Issue：[[AZ-400][2.1] 使用 Azure Pipelines 與 GitHub Actions 實作 CI](https://github.com/ge1123/Microsoft-Azure/issues/53)

狀態：待學習。本頁於 2026-09-14 依既有 Issue 整理學習大綱；尚無完成筆記或實作驗證，不代表已重新核對當期考綱。

## 學習大綱

### CI 平台與 YAML Pipeline 基礎

- 能比較 GitHub Actions 與 Azure Pipelines
- 能建立 YAML pipeline 完成 checkout、build 與 artifact publish
- 理解 stage、job、step、task／action 等核心概念

### Agents、Runners 與 Pools

- 能比較 Microsoft／GitHub-hosted 與 self-hosted 執行器
- 能設計 agent／runner infrastructure 的成本、工具、連線與維護
- 能設定 pool、需求與執行器安全性

### Triggers、順序與並行

- 能設定 branch、path、schedule、PR 或手動 trigger
- 能設計 job dependency、multi-stage 與 parallel execution
- 能控制 concurrency 以兼顧效能與成本

### 可重用 Pipeline 元件與設定

- 能使用 YAML template、reusable workflow 或 task group
- 能管理 variables、variable groups 與 environments
- 能區分一般設定與敏感資訊

### GitHub 與 Azure Pipelines 整合

- 能連結 GitHub repository 與 Azure Pipelines
- 能說明跨平台或 hybrid pipeline 的適用情境
- 能診斷基本授權與 webhook／trigger 問題

### Pipeline 測試策略

- 能規劃 local、unit、integration 與 load tests
- 能設定 test task、test agent 與測試結果整合
- 能依風險決定測試執行順序

### Code Coverage 與品質閘門

- 能收集並呈現 code coverage
- 能設定品質、release、安全或治理 gate
- 能決定失敗時阻擋、警告或例外處理方式

### Container Build 策略

- 能建立並最佳化 container image build
- 能管理 image tag、cache 與 artifact flow
- 能在 pipeline 中驗證並發佈 container image


## 筆記

待補：用自己的話整理理解、適用情境與易混淆之處；內容增加時再拆成主題檔案。

## 待確認與複習

尚未記錄。學習後補上疑問、錯誤原因與可用來自測的問題。

## 來源

以下連結沿用既有 Issue，使用時再確認版本與適用範圍。

- [官方來源 1](https://learn.microsoft.com/en-us/training/paths/az-400-implement-ci-azure-pipelines-github-actions/)

回到[認證導覽](../README.md)。
