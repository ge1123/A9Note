# AZ-104 學習網站

直接以瀏覽器開啟 [index.html](index.html)。網站使用相對路徑，可離線閱讀。

## 目錄分工

- `index.html`：所有主題的入口，新增主題時更新此頁的主題連結。
- `topics/<topic-name>.html`：獨立主題頁；目前提供 [Azure Storage](topics/azure-storage.html) 與 [Azure Networking](topics/azure-networking.html)。
- `assets/images/<topic-name>/`：各主題使用的圖片。

主題檔名與圖片資料夾使用穩定的英文名稱，例如 `azure-storage`。圖片使用 `azure_storage_01.png`、`azure_storage_02.png` 等兩位數流水號；其他主題沿用 `<topic_name>_<流水號>.png`。

主題頁提供回到 `../index.html` 的連結；圖片路徑使用 `../assets/images/<topic-name>/<圖片檔名>`。新增主題時沿用此結構，無須建立尚無內容的頁面。

GitHub Pages 發布時，此目錄會複製到 `/az-104/` 子路徑（位於 repository 網站之下）。總入口與部署方式見 [全站維護說明](../../site/README.md)。
