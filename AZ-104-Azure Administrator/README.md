# AZ-104 — Azure Administrator

## Status

Partial。此目錄保存 AZ-104 專屬的 objective mapping、筆記、題目與 labs。已於 2026-09-11 依 [官方 Study Guide](https://learn.microsoft.com/credentials/certifications/resources/study-guides/az-104) 核對 2026-04-17 生效的五大 skills measured 與權重；課程完成、labs、評量與 Azure runtime evidence 尚未驗證。

GitHub 學習追蹤從 [AZ-104 Microsoft Azure Administrator 學習路線](https://github.com/ge1123/Microsoft-Azure/issues/15) 開始。目前包含三個階段、九個第二層項目，以及 20 個細分的 compute、monitor/recovery 與官方 Lab 第三層 Sub-issues；官方 Lab 01–11 中的 02a、02b、09a、09b、09c 分別計算，共 14 個 labs。

完整筆記、來源與驗證結果記錄於本目錄；Issues 負責目標、進度與討論。其他認證請見 [學習入口](../README.md)。

## 學習網站

[AZ-104 網站入口](site/index.html)目前提供 [Azure Storage](site/topics/azure-storage.html) 與 [Azure Networking](site/topics/azure-networking.html) 主題；[網站維護說明](site/README.md)記錄目錄與連結慣例。

## 筆記與實作入口

- [Hub／Spoke + Web Load Balancer 互動式 lab](networking/labs/hub-spoke-web/README.md)：以互動式 shell 啟動 Bicep，包含配額檢查、預覽、部署、HTTP 驗收與清理；Azure runtime 待驗證。

以下為待學習骨架，依既有 Issues 整理；尚未填入實際學習成果。

| 主題 | 筆記 | Issue |
| --- | --- | --- |
| Azure 身分識別與治理 | [README](identity-governance/README.md) | [#17](https://github.com/ge1123/Microsoft-Azure/issues/17) |
| Azure 系統管理先備能力 | [README](prerequisites/README.md) | [#18](https://github.com/ge1123/Microsoft-Azure/issues/18) |
| Azure 運算資源 | [README](compute/README.md) | [#20](https://github.com/ge1123/Microsoft-Azure/issues/20) |
| Azure 儲存 | [README](storage/README.md) | [#21](https://github.com/ge1123/Microsoft-Azure/issues/21) |
| AZ-104 官方 Labs | [README](labs/README.md) | [#22](https://github.com/ge1123/Microsoft-Azure/issues/22) |
| Azure 虛擬網路 | [README](networking/README.md) | [#23](https://github.com/ge1123/Microsoft-Azure/issues/23) |
| Exam Sandbox 與考前驗收 | [README](exam-preparation/exam-sandbox/README.md) | [#24](https://github.com/ge1123/Microsoft-Azure/issues/24) |
| Practice Assessment | [README](exam-preparation/practice-assessment/README.md) | [#25](https://github.com/ge1123/Microsoft-Azure/issues/25) |
| Azure 監視、備份與復原 | [README](monitoring-recovery/README.md) | [#26](https://github.com/ge1123/Microsoft-Azure/issues/26) |
| ARM Templates 與 Bicep | [README](compute/arm-bicep/README.md) | [#27](https://github.com/ge1123/Microsoft-Azure/issues/27) |
| Azure Containers | [README](compute/containers/README.md) | [#28](https://github.com/ge1123/Microsoft-Azure/issues/28) |
| Virtual Machines 與 VM Scale Sets | [README](compute/virtual-machines/README.md) | [#29](https://github.com/ge1123/Microsoft-Azure/issues/29) |
| Lab 02a：Manage Subscriptions and RBAC | [README](identity-governance/labs/lab-02a/README.md) | [#30](https://github.com/ge1123/Microsoft-Azure/issues/30) |
| Lab 01：Manage Microsoft Entra ID Identities | [README](identity-governance/labs/lab-01/README.md) | [#31](https://github.com/ge1123/Microsoft-Azure/issues/31) |
| Azure App Service | [README](compute/app-service/README.md) | [#32](https://github.com/ge1123/Microsoft-Azure/issues/32) |
| Azure Monitor | [README](monitoring-recovery/monitor/README.md) | [#33](https://github.com/ge1123/Microsoft-Azure/issues/33) |
| Azure Backup 與 Site Recovery | [README](monitoring-recovery/backup-site-recovery/README.md) | [#34](https://github.com/ge1123/Microsoft-Azure/issues/34) |
| Lab 02b：Manage Governance via Azure Policy | [README](identity-governance/labs/lab-02b/README.md) | [#35](https://github.com/ge1123/Microsoft-Azure/issues/35) |
| Lab 03：Azure Resource Manager Templates | [README](compute/arm-bicep/labs/lab-03/README.md) | [#36](https://github.com/ge1123/Microsoft-Azure/issues/36) |
| Lab 04：Implement Virtual Networking | [README](networking/labs/lab-04/README.md) | [#37](https://github.com/ge1123/Microsoft-Azure/issues/37) |
| Lab 05：Implement Intersite Connectivity | [README](networking/labs/lab-05/README.md) | [#38](https://github.com/ge1123/Microsoft-Azure/issues/38) |
| Lab 06：Network Traffic Management | [README](networking/labs/lab-06/README.md) | [#39](https://github.com/ge1123/Microsoft-Azure/issues/39) |
| Lab 07：Manage Azure Storage | [README](storage/labs/lab-07/README.md) | [#40](https://github.com/ge1123/Microsoft-Azure/issues/40) |
| Lab 08：Manage Virtual Machines | [README](compute/virtual-machines/labs/lab-08/README.md) | [#41](https://github.com/ge1123/Microsoft-Azure/issues/41) |
| Lab 09a：Implement Web Apps | [README](compute/app-service/labs/lab-09a/README.md) | [#42](https://github.com/ge1123/Microsoft-Azure/issues/42) |
| Lab 11：Implement Monitoring | [README](monitoring-recovery/monitor/labs/lab-11/README.md) | [#43](https://github.com/ge1123/Microsoft-Azure/issues/43) |
| Lab 09c：Azure Container Apps | [README](compute/containers/labs/lab-09c/README.md) | [#44](https://github.com/ge1123/Microsoft-Azure/issues/44) |
| Lab 09b：Azure Container Instances | [README](compute/containers/labs/lab-09b/README.md) | [#45](https://github.com/ge1123/Microsoft-Azure/issues/45) |
| Lab 10：Implement Data Protection | [README](monitoring-recovery/backup-site-recovery/labs/lab-10/README.md) | [#46](https://github.com/ge1123/Microsoft-Azure/issues/46) |
