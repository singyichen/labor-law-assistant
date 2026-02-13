# Code Review Skills - 使用指南

本文件說明如何使用 Labor Law Assistant 專案的 Code Review 相關 Skills。

## 📋 可用的 Skills

### 1. `code-review` - 全面程式碼審查
**用途**: 執行完整的程式碼審查，涵蓋程式碼品質、安全性、效能、法律合規性

**使用時機**:
- 準備合併 PR 之前
- 定期程式碼健康檢查
- 重大功能開發後
- 法律計算模組變更

**輸出內容**:
- 程式碼品質問題 (命名、複雜度、重複等)
- 安全漏洞分析 (OWASP Top 10)
- 效能問題 (N+1 查詢、缺少索引)
- 法律計算正確性審查
- 測試覆蓋率分析
- 依賴項漏洞檢查
- Approve/Request Changes 建議

**範例**:
```bash
# 審查所有變更
/code-review

# 審查特定檔案
/code-review app/calculators/overtime.py

# 審查特定目錄
/code-review app/calculators/
```

**輸出格式**: Markdown 表格，包含：
- 問題分類 (Critical/High/Medium/Low)
- 具體檔案位置
- 問題描述和修改建議
- 程式碼範例

---

### 2. `code-review-checklist` - 審查檢查清單生成器
**用途**: 生成專案專用的 Code Review Checklist

**使用時機**:
- 建立 PR 模板
- 訓練新團隊成員
- 制定審查標準
- 不同模組的專用檢查清單

**輸出內容**:
- 通用檢查項目 (命名、格式、註解)
- Python/FastAPI 專用檢查
- 安全性檢查清單
- 法律計算模組專用檢查
- BDD 測試檢查清單
- 驗證命令和最佳實踐

**範例**:
```bash
# 通用檢查清單
/code-review-checklist

# 法律模組專用檢查清單
/code-review-checklist legal

# API 端點檢查清單
/code-review-checklist api

# BDD 測試檢查清單
/code-review-checklist bdd
```

**輸出格式**: 
- 分類的檢查項目 (checkbox 格式)
- 每個項目的詳細說明和範例
- 驗證命令
- 最佳實踐指引

---

### 3. `pr-review` - Pull Request 審查
**用途**: 完整的 Pull Request 審查，包括 PR 描述、範圍、影響評估

**使用時機**:
- PR 提交後、合併前
- 評估 Breaking Changes
- 審查部署風險
- 決定是否 Approve

**輸出內容**:
- PR 元資料分析 (檔案數、行數變更)
- 描述完整性評估
- 變更範圍分析 (Focused/Too Large)
- Breaking Changes 識別和影響評估
- 程式碼品質審查結果
- 測試狀態和 CI/CD 檢查
- 法律合規審查
- 安全性和效能審查
- Approve/Request Changes 建議

**範例**:
```bash
# 審查 PR
/pr-review #123

# 快速審查 (只顯示摘要)
/pr-review --quick
```

**輸出格式**:
- PR 概覽表格
- 各維度評分 (🟢/🟡/🔴)
- 詳細問題列表
- 行動項目 (Action Items)
- 時間線和里程碑

---

### 4. `code-smell` - 程式碼異味偵測
**用途**: 識別程式碼異味和反模式，提供重構建議

**使用時機**:
- 技術債評估
- 重構規劃
- 程式碼健康檢查
- 訓練和學習

**輸出內容**:
- 常見 Code Smells (Long Method, God Class, etc.)
- 按類別分類 (Bloaters, OOP Abusers, etc.)
- 嚴重程度評估
- 具體重構建議和程式碼範例
- 技術債評分
- 預防策略

**範例**:
```bash
# 偵測所有 code smells
/code-smell

# 偵測特定目錄
/code-smell app/services/

# 快速摘要
/code-smell --quick
```

**輸出格式**:
- Code Smell 清單 (依嚴重程度排序)
- 問題程式碼和重構後程式碼對比
- 技術債評分
- 重構優先順序建議

---

## 🎯 使用場景

### 場景 1: PR 提交前自我檢查
```bash
# 1. 執行完整程式碼審查
/code-review

# 2. 檢查是否符合專案標準
/code-review-checklist

# 3. 修正發現的問題後提交 PR
```

### 場景 2: 審查同事的 PR
```bash
# 1. 完整 PR 審查
/pr-review #123

# 2. 如發現問題，執行詳細程式碼審查
/code-review app/calculators/overtime.py

# 3. 提供具體修改建議
```

### 場景 3: 法律計算模組開發
```bash
# 1. 開發完成後，使用法律模組檢查清單
/code-review-checklist legal

# 2. 執行全面審查
/code-review app/calculators/

# 3. 確認法律合規性
# - 法律條文引用正確
# - 計算公式準確
# - 與政府計算機交叉驗證
```

### 場景 4: 技術債評估和重構
```bash
# 1. 偵測程式碼異味
/code-smell app/services/

# 2. 評估技術債嚴重程度
# 3. 規劃重構優先順序
# 4. 執行重構
# 5. 重新檢查
/code-smell app/services/
```

---

## 📊 審查標準

### 嚴重程度分級

| 等級 | 圖示 | 定義 | 處理方式 |
|------|------|------|----------|
| Critical | 🔴 | 安全漏洞、資料遺失風險、法律違規 | 必須立即修正 |
| High | 🟠 | 重大 bug、重大用戶影響、合規問題 | 合併前應修正 |
| Medium | 🟡 | 程式碼品質問題、小 bug、技術債 | 應該處理 |
| Low | 🟢 | 風格問題、小改進、nice-to-have | 可選修正 |

### 法律計算模組特殊要求

所有法律計算相關的程式碼必須滿足：

#### 必要條件 (Blocker)
- ✅ 所有計算引用正確的法律條文
- ✅ 與政府計算機 100% 交叉驗證
- ✅ 測試覆蓋率 ≥ 95%
- ✅ 法律團隊審查簽核
- ✅ 顯示免責聲明

#### 推薦標準
- 📝 Docstring 包含法律條文連結
- 📝 使用 Decimal 而非 float (精確度)
- 📝 測試案例來自官方文件
- 📝 記錄法律修訂歷史

---

## 🛠️ 整合到工作流程

### Git Workflow 整合

```bash
# 1. 建立功能分支
git checkout -b feature/overtime-calculation

# 2. 開發過程中定期檢查
/code-review app/calculators/overtime.py

# 3. 完成開發後全面審查
/code-review-checklist legal
/code-review

# 4. 提交 PR
git push origin feature/overtime-calculation

# 5. PR 審查
/pr-review #123

# 6. 根據審查意見修正
# 7. 重新審查直到通過
```

### CI/CD Pipeline 整合

建議在 CI/CD 中加入自動化檢查：

```yaml
# .github/workflows/code-quality.yml
name: Code Quality Check

on: [pull_request]

jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      # Linting
      - name: Run Ruff
        run: ruff check .
      
      # Type Checking
      - name: Run MyPy
        run: mypy app/ --strict
      
      # Security Scan
      - name: Run Bandit
        run: bandit -r app/
      
      # Test Coverage
      - name: Check Coverage
        run: |
          pytest --cov=app --cov-report=term
          # Fail if legal modules < 95%
      
      # Complexity Check
      - name: Check Complexity
        run: radon cc -s -a app/ --total-average
```

---

## 📚 最佳實踐

### For Code Authors (開發者)

1. **提交前自我審查**
   - 使用 `/code-review` 檢查自己的程式碼
   - 使用 `/code-review-checklist` 確保符合標準
   - 修正所有 Critical 和 High 問題

2. **清晰的 PR 描述**
   - 說明 What (做了什麼)
   - 說明 Why (為什麼需要)
   - 說明 How (如何實作)
   - 包含測試計畫
   - 標註 Breaking Changes

3. **小而專注的 PR**
   - 一個 PR 專注一個功能
   - 避免混合無關變更
   - 理想大小: < 500 行程式碼

### For Reviewers (審查者)

1. **建設性反饋**
   - 提供具體程式碼範例
   - 解釋為什麼需要改
   - 優先關注法律合規和安全性

2. **明確優先順序**
   - 標註 Critical/High/Medium/Low
   - 區分 Blocker vs Nice-to-have
   - 建議修正順序

3. **及時審查**
   - 24 小時內回應
   - 大 PR 可要求分割
   - 認可好的程式碼 (正面回饋)

### For Legal Modules (法律模組)

1. **額外審查要求**
   - 法律團隊必須審查
   - 與政府工具交叉驗證
   - 記錄法律依據和修訂歷史

2. **測試標準更高**
   - 測試覆蓋率 ≥ 95% (其他模組 80%)
   - 必須包含邊界情況測試
   - 測試案例來自官方文件

3. **文件要求**
   - Docstring 引用具體法條
   - 包含法律連結
   - 計算公式詳細說明

---

## 🔧 自訂和擴展

### 新增專案特定檢查項目

可以在 `code-review-checklist` 中新增專案特定的檢查項目：

```markdown
### Taiwan Labor Law Specific Checks

- [ ] **法律條文引用**
  - 使用完整條文編號: "勞動基準法第24條"
  - 包含修訂年份: "2019年修正"
  - 提供官方連結

- [ ] **計算精確度**
  - 使用 Decimal 而非 float
  - 四捨五入規則明確記錄
  - 邊界情況測試完整

- [ ] **免責聲明**
  - 所有計算結果顯示免責聲明
  - 不可移除或隱藏
  - 繁體中文清楚易懂
```

### 調整嚴重程度閾值

可根據專案需求調整閾值：

```python
# 預設閾值
COMPLEXITY_THRESHOLD = 10
FUNCTION_LENGTH_THRESHOLD = 50
CLASS_LENGTH_THRESHOLD = 300
TEST_COVERAGE_GENERAL = 80
TEST_COVERAGE_LEGAL = 95

# 可根據專案調整
```

---

## 📖 參考資源

### 程式碼品質工具

```bash
# 安裝建議的品質檢查工具
pip install ruff mypy bandit safety radon interrogate vulture
```

### 相關文件

- [CLAUDE.md](../../../CLAUDE.md) - 專案開發規範
- [AGENTS.md](../../AGENTS.md) - Agent 使用指南
- 現有 Skills:
  - `backend-spec` - 後端規格定義
  - `defect-report` - 缺陷報告
  - `quality-gate` - 品質門檻
  - `bdd-step-definition` - BDD 步驟定義

### 外部參考

- [勞動法令查詢系統](https://laws.mol.gov.tw/)
- [勞動部計算機](https://labweb.mol.gov.tw/calculator/)
- [Python PEP 8 Style Guide](https://peps.python.org/pep-0008/)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)

---

## 💡 常見問題

### Q1: 什麼時候使用 code-review vs pr-review?

**A**: 
- `code-review`: 專注程式碼本身 (品質、安全、效能)
- `pr-review`: 涵蓋 PR 整體 (描述、範圍、影響、部署風險)

建議：PR 審查時兩者都用，先 `/pr-review` 看整體，再 `/code-review` 看細節。

### Q2: 法律計算模組有哪些特殊要求?

**A**: 
1. 測試覆蓋率 ≥ 95% (其他模組 80%)
2. 法律團隊必須審查簽核
3. 與政府計算機交叉驗證 100% 匹配
4. Docstring 必須引用法律條文
5. 使用 Decimal (不用 float)

### Q3: Code Smell 都要修正嗎?

**A**: 不一定。優先順序:
- 🔴 Critical Smells: 立即修正 (如複雜度 > 15)
- 🟠 High Smells: 下個 sprint 修正
- 🟡 Medium Smells: 規劃重構時處理
- 🟢 Low Smells: 可選，有時間再處理

### Q4: PR 太大怎麼辦?

**A**: 
1. 要求作者分割成多個小 PR
2. 理想大小: < 500 行程式碼
3. 一個 PR 一個功能
4. 重構和新功能分開

### Q5: 如何處理 Breaking Changes?

**A**: 
1. PR 描述中明確標註
2. 提供 Migration Guide
3. 評估影響範圍 (Frontend, Mobile, API consumers)
4. 規劃 Rollout Plan (backward compatibility → deprecation → removal)
5. 通知受影響的團隊/用戶

---

## 📝 更新日誌

### 2024-02-10
- ✨ 新增 `code-review` skill
- ✨ 新增 `code-review-checklist` skill
- ✨ 新增 `pr-review` skill
- ✨ 新增 `code-smell` skill
- 📚 建立使用指南文件

---

**維護者**: Labor Law Assistant 開發團隊  
**最後更新**: 2024-02-10
