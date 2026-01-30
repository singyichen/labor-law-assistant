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

## Important Notes

- 法律內容必須準確且符合台灣最新勞動法規
- 所有法律資訊應附上適當的免責聲明
- 用戶輸入需要驗證和清理
