# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Labor Law Assistant - 台灣勞動法律查詢助手系統

## Tech Stack

- Language: Python
- Package Manager: pip / uv / poetry (TBD)

## Development Commands

```bash
# Install dependencies (update when package manager is chosen)
pip install -r requirements.txt

# Run the application
python main.py

# Run tests
pytest

# Type checking
mypy .

# Linting
ruff check .
```

## Architecture

(To be documented as the project develops)

## Communication

- 總是使用繁體中文回覆

## Code Style

- Python 使用 4 格縮排
- 變數命名使用 snake_case（禁止單字母變數）
- 所有函數必須有 docstring 說明，清楚定義其用途、所有參數、依賴關係、和預期回傳類型

## Git Workflow

- 頻繁提交：每次完成一組功能後必須 commit，需要根據提交給相對應正確的 type
- 提交訊息請涵蓋變更的全部範圍，並保持訊息簡潔
- 開始實作新功能時建立並切換到新的 Git 分支（例如，使用 git worktree 或直接創建分支）
- 永遠 *不要* 推送到 main 分支（main 或 master），避免干擾 prod 環境

## Important Notes

- 法律內容必須準確且符合台灣最新勞動法規
- 所有法律資訊應附上適當的免責聲明
- 用戶輸入需要驗證和清理

