# QA

QA pages 說明知識頁、labs 與 runtime observations 必須證明什麼；它們不取代 tests、official sources 或 Azure telemetry。

## Baseline evidence levels

| Level | Question answered | Minimum evidence |
| --- | --- | --- |
| Recall | 能否正確定義與辨識 | dated official source |
| Explain | 能否說明 boundary 與 trade-off | canonical explanation plus compared alternatives |
| Apply | 能否在明確 scope 完成設定 | source/IaC and bounded verification |
| Diagnose | 能否分類 failure 並找到原因 | reproducible symptom, queries/logs and verified cause |
| Recover | 能否安全回復與確認後置狀態 | recovery steps, final-state evidence and remaining risk |

## Baseline rules

- 每個 check 都有明確 pass/fail result。
- 將 identity/authorization、policy、control plane、network、data plane、quota、region、deployment 與 application failures 分類。
- 證據能對應 source revision、official-source checked date 與 Azure environment scope。
- 測試與 cleanup 只影響本 lab 明確擁有的 resources。
- eventual-consistency 與 timing-sensitive checks 使用有界 timeout，失敗時保留足夠且已遮罩的診斷資訊。

