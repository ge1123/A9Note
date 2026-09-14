# Microsoft Azure Learning Workspace

Azure 認證學習筆記、實作 labs 與驗證紀錄。完整筆記保存在 repo；GitHub Issues 負責學習目標、進度與討論。選擇認證目錄開始：

- [AZ-900-Azure Fundamentals](AZ-900-Azure%20Fundamentals/README.md)
- [AZ-104-Azure Administrator](AZ-104-Azure%20Administrator/README.md)
- [AI-200-Azure AI Cloud Developer](AI-200-Azure%20AI%20Cloud%20Developer/README.md)
- [AZ-500-Azure Security Engineer](AZ-500-Azure%20Security%20Engineer/README.md)
- [AZ-305-Azure Solutions Architect](AZ-305-Azure%20Solutions%20Architect/README.md)
- [AZ-400-DevOps Engineer](AZ-400-DevOps%20Engineer/README.md)

筆記、labs 與相關 artifacts 放在各認證目錄，來源連結與驗證結果就近記錄。考綱以 Microsoft 官方 Study Guide 為準，學習規劃與實作完成狀態分開標示。

## 學習方式

1. 從認證 README 找到主題與對應 Issue。
2. 在主題資料夾的 README 記錄自己的理解、比較、範例、疑問與官方來源；內容變多再拆檔。
3. 實作檔案及操作、結果、cleanup 放在主題下的 `labs/<lab-name>/`。
4. 在 Issue 更新進度、討論問題，引用筆記路徑或已推送的 commit；不重複貼整份筆記或預先建立空白模板留言。

目前學習路線：[AZ-900 #1](https://github.com/ge1123/Microsoft-Azure/issues/1)、[AZ-104 #15](https://github.com/ge1123/Microsoft-Azure/issues/15)、[AZ-400 #47](https://github.com/ge1123/Microsoft-Azure/issues/47)。其餘認證在開始學習時再建立主題。

## 資料夾慣例

```text
<認證目錄>/
├── README.md               # 主題導覽與 Issues 連結
└── <主題>/
    ├── README.md           # 摘要、筆記、來源與對應 Issue
    ├── <細分主題>.md        # 內容增加時才拆檔
    └── labs/<lab-name>/
        ├── README.md       # 前提、操作、驗證結果與 cleanup
        └── <實作檔案>       # 實際需要時才新增
```

資料夾使用穩定的主題名稱，Issue 編號記錄在文件內。既有學習大綱是規劃，完成筆記與實作後才補上結果；不要把建立檔案當作完成學習。
