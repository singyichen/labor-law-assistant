# 雙資料來源 RAG 策略

## 文件資訊

| 項目 | 內容 |
|------|------|
| **版本** | v1.0 |
| **建立日期** | 2026-02-11 |
| **負責人** | Product Manager |
| **狀態** | 待審核 |

---

## 1. 資料來源定位

### 1.1 勞基法法條資料庫（Primary Source）

**定位**：權威性法律基礎

```
角色：系統的「法律大腦」
特性：正式、權威、不可變（除非修法）
可信度：⭐⭐⭐⭐⭐ (100%)
```

**涵蓋內容**
- 勞動基準法完整法條（共 86 條）
- 勞工退休金條例（共 61 條）
- 勞工保險條例（共 81 條）
- 就業服務法（共 76 條）
- 性別工作平等法（共 40 條）
- 職業安全衛生法（共 57 條）
- 勞資爭議處理法（共 66 條）
- 大量解僱勞工保護法（共 17 條）

**資料結構**
```json
{
  "law_id": "labor_standards_act_024",
  "law_name": "勞動基準法",
  "article_number": "第 24 條",
  "content": "[法條原文]",
  "effective_date": "2024-01-01",
  "amendments": [],
  "official_url": "https://law.moj.gov.tw/...",
  "related_articles": ["labor_standards_act_030", "..."],
  "keywords": ["加班", "延長工時", "加班費"],
  "category": "工資與工時"
}
```

**更新機制**
- 來源：全國法規資料庫、勞動部公告
- 頻率：法規修正後 24 小時內同步
- 驗證：雙人審核（Legal Advisor + Content Lead）

---

### 1.2 內部文章資料庫（Secondary Source）

**定位**：實務性應用指引

```
角色：系統的「實務顧問」
特性：白話、案例化、持續優化
可信度：⭐⭐⭐⭐ (90-95%)
```

**涵蓋內容類型**

| 類型 | 數量目標 | 範例 | 優先級 |
|------|---------|------|--------|
| **FAQ 白話解答** | 100+ 篇 | 「加班費怎麼算？」「特休怎麼請？」 | P0 |
| **計算工具說明** | 10 篇 | 加班費計算器使用說明、計算邏輯 | P0 |
| **情境式引導** | 50+ 篇 | 「遇到老闆不給加班費怎麼辦？」 | P0 |
| **實務案例分析** | 30 篇 | 勞動部裁決案例、法院判決白話解析 | P1 |
| **行動指南** | 50 篇 | 證據收集方法、申訴流程 SOP | P1 |
| **產業特殊規定** | 20 篇 | 醫療業、運輸業、保全業特殊工時 | P2 |
| **政策變更解讀** | 持續更新 | 基本工資調整影響、新法令解讀 | P1 |

**資料結構**
```json
{
  "article_id": "faq_overtime_calculation_001",
  "title": "平日加班費怎麼算？完整計算教學",
  "type": "faq",
  "category": "薪資與加班",
  "target_audience": ["worker", "hr"],
  "content": "[白話文內容]",
  "legal_basis": ["labor_standards_act_024", "..."],
  "confidence_score": 0.95,
  "author": "Content Team",
  "reviewed_by": "Legal Advisor",
  "created_at": "2026-01-15",
  "updated_at": "2026-01-20",
  "version": "1.1",
  "related_articles": ["faq_overtime_rest_001", "..."],
  "keywords": ["加班費", "計算", "時薪"],
  "examples": [
    {
      "scenario": "月薪制勞工平日加班",
      "calculation": "[具體計算過程]"
    }
  ]
}
```

**品質控制**
- 所有文章必須引用法條依據（`legal_basis`）
- 三級審核：Author → Content Lead → Legal Advisor
- 定期審核（每 6 個月全面檢視）

---

## 2. 使用者查詢時的資料來源整合策略

### 2.1 RAG 檢索優先級設計

```
用戶查詢
    ↓
┌─────────────────────────────────────┐
│ Step 1: 意圖識別                    │
│ - 基礎法律查詢 → 優先法條            │
│ - 實務應用問題 → 優先內部文章        │
│ - 計算型問題 → 工具 + 說明文章       │
└─────────────────────────────────────┘
    ↓
┌─────────────────────────────────────┐
│ Step 2: 雙源並行檢索                │
│                                     │
│  [法條資料庫]     [內部文章庫]      │
│      ↓                 ↓            │
│   Top 5 法條      Top 5 文章        │
└─────────────────────────────────────┘
    ↓
┌─────────────────────────────────────┐
│ Step 3: 加權排序與整合              │
│                                     │
│ 排序邏輯：                           │
│ - 語意相似度（Embedding）            │
│ - 來源權重（法條 1.2x, 文章 1.0x）   │
│ - 新鮮度（最近 6 個月 +0.1）         │
│ - 用戶身分匹配度                     │
└─────────────────────────────────────┘
    ↓
┌─────────────────────────────────────┐
│ Step 4: LLM 生成回答                │
│                                     │
│ Prompt 範本：                        │
│ 「根據以下資料回答用戶問題：         │
│                                     │
│  【權威法條】                        │
│  - [法條 1]                         │
│  - [法條 2]                         │
│                                     │
│  【實務說明】                        │
│  - [文章 1 摘要]                    │
│  - [文章 2 摘要]                    │
│                                     │
│  請用白話文回答，必須引用法條依據」   │
└─────────────────────────────────────┘
    ↓
┌─────────────────────────────────────┐
│ Step 5: 呈現格式化輸出              │
│ (見下方 2.2 呈現策略)                │
└─────────────────────────────────────┘
```

---

### 2.2 前端呈現策略：清楚區分資料來源

#### 方案 A：分層呈現（推薦）

```markdown
┌─────────────────────────────────────────────────────┐
│ 📋 您的問題：平日加班費怎麼算？                       │
├─────────────────────────────────────────────────────┤
│                                                     │
│ ✅ 直接回答                                         │
│ 平日加班費為時薪的 1.34-1.67 倍                     │
│                                                     │
│ ─────────────────────────────────────────────────  │
│                                                     │
│ 📖 詳細說明                                         │
│                                                     │
│ 依勞動基準法規定，平日加班前 2 小時為時薪 1.34 倍， │
│ 第 3-4 小時為 1.67 倍。                             │
│                                                     │
│ 💡 白話來說：                                       │
│ 如果您的時薪是 200 元：                             │
│ • 加班第 1-2 小時：200 × 1.34 = 268 元/小時         │
│ • 加班第 3-4 小時：200 × 1.67 = 334 元/小時         │
│                                                     │
│ ─────────────────────────────────────────────────  │
│                                                     │
│ 📜 法條依據                                         │
│ ┌────────────────────────────────────────────────┐ │
│ │ 📕 勞動基準法第 24 條                           │ │
│ │                                                │ │
│ │ 雇主延長勞工工作時間者，其延長工作時間之工資，  │ │
│ │ 依下列標準加給：                               │ │
│ │ 一、延長工作時間在二小時以內者，按平日每小時   │ │
│ │     工資額加給三分之一以上。                   │ │
│ │ 二、再延長工作時間在二小時以內者，按平日每小時 │ │
│ │     工資額加給三分之二以上。                   │ │
│ │                                                │ │
│ │ 🔗 查看完整法條                                │ │
│ └────────────────────────────────────────────────┘ │
│                                                     │
│ ─────────────────────────────────────────────────  │
│                                                     │
│ 💼 實務說明                                         │
│ ┌────────────────────────────────────────────────┐ │
│ │ 📝 內部文章：加班費計算完整教學                 │ │
│ │                                                │ │
│ │ 常見疑問：                                     │ │
│ │ Q: 月薪制怎麼算時薪？                          │ │
│ │ A: 月薪 ÷ 240（每月工時上限）= 時薪            │ │
│ │                                                │ │
│ │ Q: 週六加班怎麼算？                            │ │
│ │ A: 前 8 小時 1.34 倍，第 9 小時起 1.67 倍      │ │
│ │                                                │ │
│ │ 🔗 閱讀完整文章                                │ │
│ └────────────────────────────────────────────────┘ │
│                                                     │
│ ─────────────────────────────────────────────────  │
│                                                     │
│ 🎯 您可以這樣做                                     │
│ 1. 使用加班費計算器試算 [連結]                      │
│ 2. 檢查薪資單是否符合規定                           │
│ 3. 如有爭議，可洽 1955 勞工專線                     │
│                                                     │
│ ─────────────────────────────────────────────────  │
│                                                     │
│ 📊 資訊來源                                         │
│ • 法律依據：勞動基準法第 24 條                      │
│ • 參考文章：加班費計算完整教學 (v1.2, 2026-01-15)  │
│ • 信心度：🟢 高 (有明確法條依據)                    │
│                                                     │
│ ⚖️ 本資訊僅供參考，不構成法律建議                   │
│                                                     │
│ 👍 有幫助 (245)  👎 沒幫助 (12)  🚨 回報錯誤        │
└─────────────────────────────────────────────────────┘
```

**視覺設計差異化**
- **法條**：使用書本圖示 📕、米色背景、襯線字體
- **內部文章**：使用文件圖示 📝、淺藍背景、無襯線字體
- **行動指引**：使用目標圖示 🎯、淺綠背景

---

#### 方案 B：標籤式呈現（替代方案）

```markdown
┌─────────────────────────────────────────────────────┐
│ 📋 您的問題：平日加班費怎麼算？                       │
├─────────────────────────────────────────────────────┤
│                                                     │
│ [直接回答] [詳細說明] [法條原文] [實務案例] [行動]   │
│  ─────                                              │
│                                                     │
│ ✅ 平日加班費為時薪的 1.34-1.67 倍                  │
│                                                     │
│ 📖 詳細說明...                                      │
│                                                     │
│ 📌 來源標籤：                                        │
│ [📕 勞基法§24] [📝 FAQ文章] [🧮 計算器]             │
└─────────────────────────────────────────────────────┘
```

---

### 2.3 不同場景的資料來源權重

| 用戶查詢類型 | 法條權重 | 文章權重 | 範例 |
|-------------|:--------:|:--------:|------|
| **基礎法律概念** | 80% | 20% | 「勞基法第 24 條是什麼？」 |
| **權益判斷** | 70% | 30% | 「老闆這樣做違法嗎？」 |
| **計算方法** | 40% | 60% | 「加班費怎麼算？」 |
| **實務操作** | 30% | 70% | 「要準備什麼證據？」 |
| **申訴流程** | 20% | 80% | 「如何向勞工局申訴？」 |
| **案例參考** | 30% | 70% | 「有類似案例嗎？」 |

**實作方式**
```python
def calculate_source_weight(query_intent):
    """
    Calculate weighting for legal articles vs internal content
    based on query intent classification.

    Args:
        query_intent: Classified intent type

    Returns:
        tuple: (law_weight, article_weight)
    """
    intent_weights = {
        "legal_concept": (0.8, 0.2),
        "rights_violation": (0.7, 0.3),
        "calculation": (0.4, 0.6),
        "practical_action": (0.3, 0.7),
        "complaint_process": (0.2, 0.8),
        "case_reference": (0.3, 0.7)
    }
    return intent_weights.get(query_intent, (0.5, 0.5))
```

---

## 3. 資料範圍擴展策略

### 3.1 法規資料庫擴展計畫

**MVP（必須涵蓋）**
- ✅ 勞動基準法（86 條）- P0
- ✅ 勞工退休金條例（61 條）- P0
- ✅ 勞工保險條例（81 條）- P0
- ✅ 就業服務法（核心章節）- P0

**Phase 2（重要補充）**
- ⏳ 性別工作平等法（40 條）- P1
- ⏳ 職業安全衛生法（核心章節）- P1
- ⏳ 勞資爭議處理法（核心章節）- P1

**Phase 3（進階擴展）**
- 📋 大量解僱勞工保護法 - P2
- 📋 相關施行細則與解釋函 - P2
- 📋 勞動部公告與行政規則 - P2

**總計**：約 400+ 條法條，預估 Vector DB 儲存量約 2-3 萬筆（含拆分段落）

---

### 3.2 內部文章類型規劃

#### A. FAQ 白話解答（100-150 篇）

**類別分布**
| 類別 | 數量 | 範例 |
|------|:----:|------|
| 💰 薪資與加班 | 30 篇 | 加班費計算、最低工資、薪資扣款 |
| 🏖️ 請假與休息 | 25 篇 | 特休計算、病假規定、例假與休息日 |
| 👋 離職與資遣 | 20 篇 | 離職預告期、資遣費計算、非法解雇 |
| 🔒 勞健保與退休金 | 15 篇 | 投保薪資、退休金提繳、給付申請 |
| ⚠️ 職場問題 | 15 篇 | 職場霸凌、性騷擾、職業災害 |
| 📋 其他 | 10 篇 | 勞動契約、試用期、競業禁止 |

---

#### B. 實務案例分析（30-50 篇）

**案例來源**
1. 勞動部不當勞動行為裁決案例（去識別化）
2. 法院勞資爭議判決（公開判決書）
3. 勞工局調解案例（經同意公開者）

**範本結構**
```markdown
# 案例：未給付加班費爭議

## 案例背景
[情境描述，去識別化]

## 爭議焦點
- 問題 1: [具體爭點]
- 問題 2: [具體爭點]

## 法律分析
[引用相關法條與解釋]

## 判決/裁決結果
[結果與理由]

## 對勞工的啟示
1. [實務建議 1]
2. [實務建議 2]

## 相關法條
- 勞基法第 X 條
- 勞基法第 Y 條
```

---

#### C. 行動指南（50 篇）

**類型**
1. **證據收集指南**（10 篇）
   - 如何保留出勤記錄
   - 如何錄音存證
   - 如何保存通訊軟體對話

2. **申訴流程 SOP**（15 篇）
   - 勞工局申訴流程
   - 勞資爭議調解申請
   - 法律扶助申請

3. **權益自我檢測**（15 篇）
   - 薪資單健檢清單
   - 勞動契約檢查要點
   - 離職流程注意事項

4. **緊急應對指南**（10 篇）
   - 遭遇職災立即處理
   - 突然被解雇怎麼辦
   - 遭遇性騷擾保護自己

---

#### D. 產業特殊規定（20-30 篇）

台灣勞基法針對特定行業有特殊規定（84-1 責任制、變形工時等）

**優先處理產業**
| 產業 | 特殊規定 | 涵蓋人數 |
|------|---------|---------|
| 醫療保健業 | 變形工時、輪班制 | 約 40 萬人 |
| 運輸業 | 特殊工時、例外規定 | 約 30 萬人 |
| 保全業 | 84-1 責任制 | 約 10 萬人 |
| 餐飲服務業 | 變形工時 | 約 80 萬人 |
| 製造業 | 輪班制、加班規定 | 約 300 萬人 |

---

### 3.3 資料更新頻率建議

| 資料類型 | 更新觸發條件 | SLA | 負責團隊 |
|---------|-------------|-----|---------|
| **法條資料庫** | 法規公告修正 | 24 小時 | Legal + Dev |
| **FAQ 文章** | 用戶回饋、錯誤回報 | 7 天 | Content Team |
| **實務案例** | 新增重要判決 | 30 天 | Legal Team |
| **行動指南** | 流程變更 | 14 天 | Content Team |
| **產業規定** | 行業規則變更 | 14 天 | Legal + Content |
| **計算工具說明** | 法規修正影響計算 | 24 小時 | Dev + Content |

**監控機制**
```python
# 法規監控爬蟲（每日執行）
def monitor_legal_updates():
    """
    Monitor Taiwan MOL and legal database for regulation updates.

    Data sources:
    - https://law.moj.gov.tw (全國法規資料庫)
    - https://www.mol.gov.tw (勞動部公告)

    Alert: Email + Slack notification when updates detected
    """
    pass
```

---

## 4. 產品路線圖（18 個月）

### Phase 0: 基礎建設（Week 1-11）

**法條資料庫**
```
Week 1-4: 資料收集與結構化
- [ ] 爬取全國法規資料庫（8 大法規）
- [ ] 建立結構化 JSON Schema
- [ ] 法條拆分與向量化（Embedding）
- [ ] 建立關聯關係（相關法條、關鍵字）

Week 5-8: Vector DB 建置
- [ ] 選型決策（Pinecone / Qdrant / Weaviate）
- [ ] 資料匯入與索引建立
- [ ] 檢索效能測試（目標 < 1 秒）
- [ ] 建立版本控制機制

Week 9-11: RAG Pipeline 開發
- [ ] 實作雙源檢索邏輯
- [ ] 加權排序演算法
- [ ] LLM Prompt 工程
- [ ] 信心度評分機制
```

**內部文章資料庫**
```
Week 1-11 (並行):
- [ ] 內容策略文件（已完成 ✅）
- [ ] 撰寫 MVP Top 50 FAQ
- [ ] 法務審核流程建立
- [ ] CMS 系統選型與建置
```

---

### Phase 1: MVP 開發（Week 12-28）

**目標**：核心功能可用

**里程碑**
- ✅ 8 大法規 100% 涵蓋（約 400 條法條）
- ✅ Top 100 FAQ 完成
- ✅ 基礎 RAG 問答功能
- ✅ 來源清楚標示
- ✅ 信心度機制

**內容產出**
```
Sprint 1-2 (Week 12-15): 勞基法核心內容
- 50 篇 FAQ（薪資、加班、請假）
- 勞基法全文向量化

Sprint 3-4 (Week 16-19): 勞保勞退內容
- 30 篇 FAQ
- 勞保勞退法條向量化

Sprint 5-6 (Week 20-23): 其他法規
- 20 篇 FAQ
- 其他 6 部法規向量化

Sprint 7-8 (Week 24-28): 整合與優化
- 10 篇行動指南
- RAG 效能調校
- 使用者測試
```

---

### Phase 2: 優化與擴展（Week 29-40）

**深度內容**
- 30 篇實務案例分析
- 20 篇產業特殊規定
- 40 篇行動指南

**工具整合**
- 加班費計算器 + 說明文章
- 特休計算器 + 說明文章
- 資遣費計算器 + 說明文章

**多語言**
- 簡易中文版本（核心 50 篇）
- 越南語/印尼語（核心 30 篇）

---

### Phase 3: 持續優化（Week 41+）

**數據驅動優化**
- 監控低滿意度回答，重寫內部文章
- A/B 測試不同呈現格式
- 根據用戶查詢補充缺失內容

**內容擴展**
- 新增用戶高頻查詢主題
- 補充冷門但重要的法規
- 更新法規修正內容

---

## 5. 風險評估與緩解策略

### 5.1 法規內容準確性風險

| 風險 | 影響 | 機率 | 緩解策略 |
|------|------|:----:|---------|
| 法條爬取錯誤 | 極高 | 低 | • 雙源驗證（MOJ + MOL）<br>• 人工抽查 10% 樣本<br>• 用戶回報機制 |
| 法規修正未同步 | 極高 | 中 | • 每日監控爬蟲<br>• Email/Slack 即時通知<br>• SLA 24 小時更新 |
| 法條解釋有爭議 | 高 | 中 | • 標示「不同見解」<br>• 引用勞動部解釋函<br>• 建議諮詢專業 |

**技術實作**
```python
class LegalContentValidator:
    """
    Validate legal content accuracy against official sources.

    Validation checks:
    - Cross-reference with multiple official sources
    - Version control and change detection
    - Human review sampling
    """

    def validate_article(self, article_number: str) -> dict:
        """
        Validate a legal article against official sources.

        Args:
            article_number: Legal article identifier

        Returns:
            Validation result with confidence score
        """
        pass
```

---

### 5.2 內部文章品質風險

| 風險 | 影響 | 機率 | 緩解策略 |
|------|------|:----:|---------|
| 白話文轉換失真 | 高 | 中 | • 三級審核制度<br>• 必須引用法條依據<br>• 定期回溯檢查 |
| 案例解讀偏誤 | 高 | 中 | • Legal Advisor 必審<br>• 標示「僅供參考」<br>• 複雜案件不處理 |
| 內容過時未更新 | 中 | 高 | • 每 6 個月全面審核<br>• 法規變更時主動盤點<br>• 標示更新日期 |

**三級審核流程**
```
Level 1: 作者自我檢查
    → 30+ 項檢查清單
         ↓
Level 2: Content Lead 同儕審核
    → 可讀性、完整性、一致性
         ↓
Level 3: Legal Advisor 法律審核
    → 準確性、風險管理
         ↓
    通過 → 發布
```

---

### 5.3 兩種來源權重處理風險

| 風險 | 影響 | 機率 | 緩解策略 |
|------|------|:----:|---------|
| AI 偏好內部文章忽略法條 | 極高 | 中 | • Prompt 強制要求引用法條<br>• 法條權重加成（1.2x）<br>• 監控引用率 |
| 兩源資訊衝突 | 高 | 低 | • 內部文章必須引用法條<br>• 衝突時優先法條<br>• 標示不一致並通知審核 |
| 用戶混淆資訊來源 | 中 | 中 | • 清楚視覺區分<br>• 標示「權威依據」vs「實務說明」 |

**Prompt 工程範例**
```python
SYSTEM_PROMPT = """
You are a Taiwan labor law assistant. When answering:

CRITICAL RULES:
1. ALWAYS cite specific legal articles as primary basis
2. Use internal articles only as supplementary explanation
3. If legal articles and internal content conflict, prioritize legal articles
4. If uncertain, clearly state limitations and suggest professional consultation

Answer structure (mandatory):
1. Direct answer (30 words max)
2. Detailed explanation in plain Chinese
3. Legal basis: cite specific article numbers
4. Practical guidance (from internal articles)
5. Confidence level indicator

Sources available:
- Legal articles: {legal_context}
- Internal articles: {internal_context}

User question: {user_query}
"""
```

---

## 6. 成功指標（KPI）

### 6.1 資料品質指標

| 指標 | 定義 | 目標值 | 測量方式 |
|------|------|--------|---------|
| **法條準確率** | 法條內容與官方一致 | 100% | 季度人工抽查 100 條 |
| **內部文章準確率** | 無錯誤回報的文章比例 | > 98% | 錯誤回報率 |
| **來源引用率** | 回答有引用法條的比例 | > 95% | 系統自動統計 |
| **信心度校準** | 高信心度回答的正確率 | > 98% | 人工評測 |
| **內容新鮮度** | 6 個月內更新的文章比例 | > 90% | 系統統計 |

---

### 6.2 檢索效能指標

| 指標 | 目標值 | 測量工具 |
|------|--------|---------|
| RAG 檢索時間 (P95) | < 1 秒 | APM |
| LLM 生成時間 (P95) | < 5 秒 | APM |
| 總回應時間 (P95) | < 6 秒 | Frontend tracking |
| 檢索相關性 (Recall@5) | > 90% | 人工評測 |

---

### 6.3 用戶體驗指標

| 指標 | 目標值 | 說明 |
|------|--------|------|
| 回答有用率 | > 85% | 獲得「👍」的比例 |
| 法條點擊率 | > 40% | 點擊「查看完整法條」的比例 |
| 內部文章點擊率 | > 30% | 點擊「閱讀完整文章」的比例 |
| 行動指南使用率 | > 50% | 點擊「您可以這樣做」連結 |
| 錯誤回報率 | < 2% | 點擊「🚨 回報錯誤」比例 |

---

## 7. 實作建議

### 7.1 技術架構建議

```
┌─────────────────────────────────────────────────────────┐
│                    Frontend (Next.js)                   │
│  - 查詢介面                                              │
│  - 分層資訊呈現                                          │
│  - 來源標示與視覺差異化                                   │
└─────────────────────────────────────────────────────────┘
                            ↓ HTTP/REST
┌─────────────────────────────────────────────────────────┐
│                 Backend API (FastAPI)                   │
│                                                         │
│  ┌─────────────────────────────────────────────────┐  │
│  │ RAG Service                                      │  │
│  │  - Query intent classification                   │  │
│  │  - Dual-source retrieval                         │  │
│  │  - Weighted ranking                              │  │
│  │  - LLM prompt engineering                        │  │
│  │  - Confidence scoring                            │  │
│  └─────────────────────────────────────────────────┘  │
│                                                         │
│  ┌─────────────────────────────────────────────────┐  │
│  │ Content Management                               │  │
│  │  - CRUD operations                               │  │
│  │  - Version control                               │  │
│  │  - Review workflow                               │  │
│  └─────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
          ↓                                    ↓
┌──────────────────────┐          ┌──────────────────────┐
│  Vector DB           │          │  PostgreSQL          │
│  (Pinecone/Qdrant)   │          │                      │
│                      │          │  - Article metadata  │
│  - Legal embeddings  │          │  - User feedback     │
│  - Article embeddings│          │  - Analytics         │
└──────────────────────┘          └──────────────────────┘
          ↓
┌─────────────────────────────────────────────────────────┐
│              LLM API (Claude 3.5 Sonnet)                │
└─────────────────────────────────────────────────────────┘
```

---

### 7.2 資料結構設計

#### Legal Articles Table (Vector DB Metadata)
```json
{
  "id": "labor_standards_act_024",
  "law_name": "勞動基準法",
  "article_number": "第 24 條",
  "category": "工資與工時",
  "keywords": ["加班", "延長工時", "加班費", "工資"],
  "effective_date": "2024-01-01",
  "last_amendment": "2023-06-01",
  "official_url": "https://law.moj.gov.tw/...",
  "content": "[法條完整內容]",
  "content_chunks": ["段落1", "段落2", ...],
  "related_articles": ["labor_standards_act_030", ...],
  "embedding": [0.123, -0.456, ...],
  "version": "1.0"
}
```

#### Internal Articles Table (PostgreSQL + Vector DB)
```sql
CREATE TABLE internal_articles (
    article_id VARCHAR(100) PRIMARY KEY,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    type VARCHAR(50) NOT NULL, -- faq, case_study, action_guide, etc.
    category VARCHAR(50) NOT NULL,
    target_audience TEXT[], -- ['worker', 'hr', 'employer']
    legal_basis TEXT[], -- ['labor_standards_act_024', ...]
    confidence_score DECIMAL(3,2) DEFAULT 0.90,
    author VARCHAR(100),
    reviewed_by VARCHAR(100),
    legal_reviewer VARCHAR(100),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    version VARCHAR(10),
    status VARCHAR(20) DEFAULT 'draft', -- draft, review, published, archived
    metadata JSONB
);

CREATE INDEX idx_category ON internal_articles(category);
CREATE INDEX idx_type ON internal_articles(type);
CREATE INDEX idx_target_audience ON internal_articles USING GIN(target_audience);
```

---

### 7.3 檢索演算法範例

```python
from typing import List, Dict
import numpy as np

class DualSourceRAG:
    """
    Dual-source RAG retrieval with weighted ranking.

    Combines legal articles and internal content with
    configurable weighting based on query intent.
    """

    def __init__(self, vector_db, legal_weight: float = 1.2):
        self.vector_db = vector_db
        self.legal_weight = legal_weight

    def retrieve(
        self,
        query: str,
        query_intent: str = "general",
        top_k: int = 5
    ) -> Dict[str, List[Dict]]:
        """
        Retrieve and rank content from both sources.

        Args:
            query: User query string
            query_intent: Classified intent type
            top_k: Number of results to return per source

        Returns:
            Dictionary with ranked results from both sources
        """
        # Generate query embedding
        query_embedding = self.embed_query(query)

        # Retrieve from legal articles
        legal_results = self.vector_db.search(
            collection="legal_articles",
            query_vector=query_embedding,
            top_k=top_k * 2  # Retrieve more for reranking
        )

        # Retrieve from internal articles
        internal_results = self.vector_db.search(
            collection="internal_articles",
            query_vector=query_embedding,
            top_k=top_k * 2
        )

        # Apply weighting and rerank
        legal_scored = self._apply_weighting(
            legal_results,
            weight=self.legal_weight,
            query_intent=query_intent
        )

        internal_scored = self._apply_weighting(
            internal_results,
            weight=1.0,
            query_intent=query_intent
        )

        # Return top K from each source
        return {
            "legal": legal_scored[:top_k],
            "internal": internal_scored[:top_k]
        }

    def _apply_weighting(
        self,
        results: List[Dict],
        weight: float,
        query_intent: str
    ) -> List[Dict]:
        """
        Apply weighting based on source type and query intent.

        Scoring factors:
        - Semantic similarity (from vector DB)
        - Source weight (legal articles boosted)
        - Recency (content updated in last 6 months)
        - Intent matching
        """
        scored_results = []

        for result in results:
            base_score = result['score']

            # Apply source weight
            weighted_score = base_score * weight

            # Recency bonus (10% boost if updated in last 6 months)
            if self._is_recent(result['metadata']['updated_at']):
                weighted_score *= 1.1

            # Intent matching bonus
            if self._matches_intent(result, query_intent):
                weighted_score *= 1.05

            result['final_score'] = weighted_score
            scored_results.append(result)

        # Sort by final score
        return sorted(
            scored_results,
            key=lambda x: x['final_score'],
            reverse=True
        )

    def _is_recent(self, updated_at: str) -> bool:
        """Check if content was updated in last 6 months."""
        # Implementation details
        pass

    def _matches_intent(self, result: Dict, intent: str) -> bool:
        """Check if result matches query intent."""
        # Implementation details
        pass
```

---

## 8. 下一步行動建議

### 立即行動（Week 1-2）

#### 技術決策
- [ ] **Vector DB 選型**：建議 Pinecone（快速上線）或 Qdrant（自託管）
- [ ] **Embedding Model 選型**：建議 `text-embedding-3-large` (OpenAI) 或 `intfloat/multilingual-e5-large`
- [ ] **LLM 選型**：建議 Claude 3.5 Sonnet（繁體中文強、長 context、指令遵循佳）

#### 資料準備
- [ ] 建立法條爬蟲（全國法規資料庫 + 勞動部網站）
- [ ] 設計 Metadata Schema
- [ ] 撰寫 10 篇 MVP FAQ 試稿

#### 流程建立
- [ ] 三級審核流程 SOP
- [ ] 法規更新監控機制
- [ ] 錯誤回報處理流程

---

### 短期目標（Week 3-8）

- [ ] 完成勞基法全文結構化（86 條）
- [ ] 完成 Top 50 FAQ 撰寫與審核
- [ ] 建立 Vector DB 並匯入資料
- [ ] 開發 RAG 檢索 MVP
- [ ] 進行第一輪內部測試

---

### 中期目標（Week 9-28）

- [ ] 8 大法規 100% 涵蓋
- [ ] 150 篇內部文章完成
- [ ] RAG 系統效能優化（< 6 秒回應）
- [ ] 前端呈現功能完整
- [ ] Beta 測試（100 名用戶）

---

## 9. 參考文件

### 已建立文件
- [Product Requirements Document](/docs/PRD.md)
- [內容策略總綱](/docs/strategy/content-strategy.md)
- [法律內容撰寫指南](/docs/content-guidelines/legal-content-guide.md)
- [AI 回答品質標準](/docs/content-guidelines/ai-response-quality.md)

### 待建立文件
- [ ] RAG 系統技術規格書
- [ ] Vector DB Schema 設計文件
- [ ] 法規更新監控 SOP
- [ ] 內部文章審核檢查表
- [ ] 資料來源權重調校指南

---

## 變更記錄

| 版本 | 日期 | 變更內容 | 作者 |
|------|------|---------|------|
| 1.0 | 2026-02-11 | 初版建立（雙資料來源策略） | Product Manager |

---

## 審核簽核

| 角色 | 姓名 | 日期 | 簽核 |
|------|------|------|------|
| Product Owner | | | ☐ |
| Tech Lead | | | ☐ |
| Legal Advisor | | | ☐ |
| Content Lead | | | ☐ |

---

**文件版本**：v1.0
**建立日期**：2026-02-11
**負責人**：Product Manager
**下次審核**：2026-03-11
