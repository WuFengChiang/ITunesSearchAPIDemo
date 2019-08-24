#  開發說明

### TDD & Refactory

- 此 assignment 的實作始於 M800AssignmentTests.swift。
- 運用 TDD 精神對 iTunes Search API 進行實作及試驗/試錯。
- 運用 Unit Test 穩固重構的結果，使得程式碼能從最平舖直述的簡單形式，逐步收斂、封裝成可重複使用的 production code。
- 其重構結果為 helper/ITunesSearchAPIHelper.swift

### Git

- 上述開發經過皆使用 Git 做好歷程記錄，以茲查詢。

### 未加入的 non-function 功能

以下為此 assignment 未加入，但是若有需求的話，可以往下實作的部分：

- 離線使用。

結合 CodeData 將 Song 結構銜接到 persistence 是直覺的，如此一來可以讓此 App 在離線情形時能瀏覽前次搜尋結果、也可以將 database 做為 cache 的載體使用。

- 因應網路狀態的 UX 提升。

1. 此例中，Search API 的使用上，是採同步執行的。(專輯圖片是非同步)
2. 歌曲搜尋結果的等待在此 App 的使用上是必須的；但是若有其他的使用情願時，連同歌曲搜尋都要採用非同步的方式的話 (例如：有其他可以離線使用的功能)，可以再加入設計。
3. 此 assignment 不採用第三方程式框架。若採用 Alamofire、SDWebImage 可以更容易達到對不同網路狀況的因應效能改善。
4. 若網路狀況極差時，下載過程中，可以再加上 HUD 層，讓使用者對 App 的執行更有感覺。


