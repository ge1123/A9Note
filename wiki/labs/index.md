# Labs

Labs 是可獨立理解、可重現、可清理、可驗證的學習切片。每個 lab 限制 scope，保存 success path 與至少一個相關 failure path 的證據。

## Registry

目前尚無已定義 lab。

| Lab | Certification mapping | Status | Evidence |
| --- | --- | --- | --- |
| None | — | — | — |

## Lab completion rule

Lab 只有在下列項目都存在時才完成：

1. 明確 learning question、in-scope、out-of-scope 與 certification mapping。
2. 明確 tenant/subscription/resource group/region、identity、permission、cost 與 cleanup boundary。
3. 可從已描述 preconditions 執行的 setup 與 verification commands。
4. 一個 observable success result 與相關 failure result。
5. source/IaC/test/runtime 的 evidence links，以及不被本 lab 證明的事項。

