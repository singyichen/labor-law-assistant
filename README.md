# Labor Law Assistant

台灣勞動法律查詢助手系統 | Taiwan Labor Law Query Assistant

A comprehensive platform for querying and understanding Taiwan labor laws and regulations.

## Features

- **Labor Law Query** - Search and browse Taiwan labor regulations
- **Overtime Calculator** - Calculate overtime pay based on Labor Standards Act
- **Leave Calculator** - Calculate annual leave entitlements
- **FAQ** - Common questions about workplace rights
- **Legal Updates** - Latest amendments and regulatory changes

## Tech Stack

- **Language**: Python 3.11+
- **Framework**: TBD (FastAPI / Django)
- **Database**: TBD (PostgreSQL / SQLite)
- **AI/LLM**: TBD (OpenAI / Claude / Local LLM)

## Getting Started

### Prerequisites

- Python 3.11 or higher
- pip / uv / poetry (package manager)

### Installation

```bash
# Clone the repository
git clone https://github.com/singyichen/labor-law-assistant.git
cd labor-law-assistant

# Create virtual environment
python -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
```

### Running the Application

```bash
# Run the application
python main.py

# Run tests
pytest

# Run linting
ruff check .

# Run type checking
mypy .
```

## Project Structure

```
labor-law-assistant/
├── .claude/                 # Claude Code configuration
│   ├── agents/              # AI expert agents (45 agents)
│   └── AGENTS.md            # Agent directory documentation
├── src/                     # Source code (TBD)
├── tests/                   # Test files (TBD)
├── docs/                    # Documentation (TBD)
├── CLAUDE.md                # Claude Code project guidelines
├── README.md                # This file
├── LICENSE                  # License file
└── requirements.txt         # Python dependencies (TBD)
```

## Development

### Code Style

- Python uses 4-space indentation
- Variable naming uses snake_case
- All functions must have docstrings with type hints
- Use pytest for testing
- Use f-strings for string formatting

### Git Workflow

- Create feature branches for new features
- Never push directly to main branch
- Commit frequently with descriptive messages
- Follow conventional commit format

### AI Agents

This project includes 45 specialized AI agents for development workflow. See [.claude/AGENTS.md](.claude/AGENTS.md) for the complete agent directory.

## Legal Disclaimer

The information provided by this system is for general reference only and does not constitute legal advice. For specific cases, please consult a qualified attorney.

本系統提供的資訊僅供參考，不構成法律建議。具體案件請諮詢專業律師。

## Covered Regulations

- Labor Standards Act (勞動基準法)
- Labor Pension Act (勞工退休金條例)
- Employment Service Act (就業服務法)
- Occupational Safety and Health Act (職業安全衛生法)
- Act of Gender Equality in Employment (性別工作平等法)
- Act for Settlement of Labor-Management Disputes (勞資爭議處理法)
- Labor Union Act (工會法)
- Mass Layoff Protection Act (大量解僱勞工保護法)

## Contributing

Contributions are welcome! Please read our contributing guidelines before submitting a pull request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'feat: add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

- GitHub: [@singyichen](https://github.com/singyichen)

## Acknowledgments

- Taiwan Ministry of Labor for providing labor law resources
- All contributors who help improve this project
