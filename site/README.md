# 學習網站維護

`site/index.html` 是所有認證的總入口。目前發布 AZ-104；尚無網站內容的認證僅顯示文字，不建立空白頁面或連結。

## 本機建置與預覽

執行位置：repository 根目錄。前提：Python 3；不需要 Azure 登入或任何 Azure 權限。

```sh
python3 scripts/build-pages.py
python3 -m http.server 8000 --directory _site
```

瀏覽 `http://localhost:8000/`。建置程式會重新產生 `_site/`，並檢查 HTML 的本機 `href` 與 `src` 路徑；不檢查外部 URL 或頁內錨點。`_site/` 已加入 `.gitignore`，不提交產物。

總入口的認證連結對應組合後的目錄，因此預覽時應開啟 `_site/`，不要直接開啟原始 `site/index.html`。

## GitHub Pages 部署

1. 將網站原始碼、建置程式及 `.github/workflows/pages.yml` 提交並推送／合併至 repository 預設分支。AZ-104 的 HTML 與圖片也必須一併納入 Git。
2. 在 GitHub repository 的 **Settings → Pages → Build and deployment → Source** 選擇 **GitHub Actions**。需要可修改 repository 設定的權限。
3. 到 **Actions → Deploy learning site to GitHub Pages → Run workflow**，選取預設分支執行首次部署。
4. 之後預設分支的網站、建置程式或 workflow 變更會自動部署；其他分支會略過。部署成功後，以 workflow 顯示的網址確認實際發布結果。

在未設定自訂網域的情況下，預期入口是 `https://ge1123.github.io/Microsoft-Azure/`，AZ-104 位於其 `az-104/` 路徑。此處為預期網址，不表示已部署或已驗證線上可用。

Workflow 使用 GitHub Pages artifact，只發布組合後的 `_site/`。不會建立 Azure 資源。

## 新增認證

1. 在對應認證目錄建立 `site/index.html` 與實際網站內容。
2. 在 [建置程式](../scripts/build-pages.py) 的 `SITES` 新增路徑對應，例如 `"az-900": "AZ-900-Azure Fundamentals/site"`。
3. 在 [總入口](index.html) 加上 `./az-900/` 連結，並更新對應認證 README。
4. 執行本機建置並預覽，確認連結與圖片後再提交。

使用相對連結，避免 `/az-104/` 這類從網域根目錄開始、遺漏 `/Microsoft-Azure/` 的路徑。認證內部的 `topics/`、`assets/` 結構完整複製，不需要改寫既有路徑。

官方參考：[GitHub Pages 自訂 workflows](https://docs.github.com/en/pages/getting-started-with-github-pages/using-custom-workflows-with-github-pages)。
