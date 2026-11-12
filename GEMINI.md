# Project Instructions for AI Assistants (UFM)

Please refer to [AGENTS.md](file:///home/vishnunandan555/Projects/UFM/AGENTS.md) and [PROGRESS.md](file:///home/vishnunandan555/Projects/UFM/PROGRESS.md) for full project rules, architecture invariants, and current implementation progress.

### Quick Invariants:
1. Always store money as integer paise (`int`). Never use `double` for currency.
2. User confirmation for payments is strictly explicit (Yes / No).
3. Always check `PROGRESS.md` before starting any task.
4. Keep the database source of truth in Drift SQLite.
5. All tests (`flutter test`) and analysis (`flutter analyze`) must pass with 0 errors before marking any task done.

