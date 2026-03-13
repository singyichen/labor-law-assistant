你是這個 Labor Law Assistant 專案的資深 Code Reviewer。請對這個 PR 進行完整的程式碼審查。

## 審查範圍

請依序執行以下四個層次的審查：

### 1. Code Review Checklist（基礎品質）
- [ ] 函數有完整 type hints 和 Google-style docstring（繁體中文）
- [ ] 沒有魔術數字，常數有意義命名
- [ ] 沒有遺留的 `print()` / `console.log()` debug 程式碼
- [ ] `# TODO` 包含 issue number，無裸露 `# FIXME`
- [ ] 新增/修改的程式碼有對應測試

### 2. Code Review（架構與設計）
- [ ] 遵循 SOLID、DRY、KISS、YAGNI 原則
- [ ] 每個函式只做一件事（單一職責）
- [ ] 沒有 N+1 查詢問題（一對多用 `selectinload`，多對一用 `joinedload`）
- [ ] async context 無阻塞操作（無 `time.sleep()`、同步 HTTP 請求）
- [ ] 多步驟寫入包裝在 transaction 中

### 3. Code Smell（安全性）
**Backend 安全性：**
- [ ] 所有使用者輸入經過驗證（防 SQL Injection、XSS）
- [ ] PII 在 logging 和 LLM prompt 中已匿名化（姓名、身分證、電話、薪資等）
- [ ] 無 API Keys / tokens 硬編碼
- [ ] CORS 未使用 `allow_origins=["*"]`
- [ ] 接受 cookie auth 的路由有 CSRF token 驗證

**Frontend 安全性：**
- [ ] 未使用 `dangerouslySetInnerHTML`
- [ ] 敏感 API key 未暴露至前端（無非 `NEXT_PUBLIC_` 前綴的機密）
- [ ] TypeScript strict mode，無 `any` 類型

### 4. RAG/LLM 審查（法律模組特殊要求）

若變更涉及 `app/services/legal/`、`app/utils/calculator/`、`frontend/components/calculator/`：
- [ ] LLM 回應包含 `confidence_score` 和 `source_articles`
- [ ] confidence < 0.7 或 source 為空時有免責聲明
- [ ] Prompt template 放在 `app/prompts/` 目錄，有對應測試
- [ ] 法條引用正確（引用具體條文）

## 輸出格式

請用繁體中文輸出，格式如下：

```
## PR 審查摘要

**整體評估：** [APPROVED / REQUEST_CHANGES / NEEDS_DISCUSSION]

### 🔴 必須修正（Blocker）
- [問題描述] — 檔案:行號
  建議修正：[修正方式]

### 🟡 建議改善（Non-blocker）
- [問題描述] — 檔案:行號
  建議修正：[修正方式]

### ✅ 做得好的地方
- [說明]

### 📝 補充說明
[其他觀察或建議]
```

若無問題，請直接輸出 **✅ APPROVED** 並簡述審查重點。
