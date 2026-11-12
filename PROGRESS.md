# UFM Project Progress & State Tracker

> **Single Source of Truth for Agents & Developers**  
> Last updated: 2026-11-12 (Project kickoff)

---

## 📌 Overall Project Status

| Phase | Description | Status | Completion % |
| :--- | :--- | :--- | :--- |
| **Phase 0** | Project Bootstrap (Flutter, Theme, Navigation Shell, CI/Lint) | ✅ Completed | 100% |
| **Phase 1** | Financial Foundation (Drift DB, Schema, Ledger, Transfers) | ✅ Completed | 100% |
| **Phase 2** | Core UI (Accounts, Income/Expense, Transfer, History) | ⏳ Next | 0% |
| **Phase 3** | Scanner & UPI URI Parser (Fixtures, QR review screen) | ⚪ Not Started | 0% |
| **Phase 4** | App Discovery, Intent Launch & Fake UPI Test App | ⚪ Not Started | 0% |
| **Phase 5** | Payment Lifecycle (Yes/No Dialog, State Recovery, Ledger linkage) | ⚪ Not Started | 0% |
| **Phase 6** | Summaries, Polish, Backup/Restore, Real-device verification | ⚪ Not Started | 0% |

---

## 🎯 Current Focus: Phase 1 — Financial Foundation

### Phase 0 Checklist (Complete)
- [x] Create `AGENTS.md` to guide any new agent or conversation
- [x] Create `PROGRESS.md` live tracking document
- [x] Initialize Flutter project (`flutter create --org com.ufm.tracker --project-name ufm --platforms android .`)
- [x] Configure `pubspec.yaml` with verified production dependencies:
  - `flutter_riverpod` (state management)
  - `drift`, `sqlite3_flutter_libs`, `path_provider`, `path` (local SQLite database)
  - `go_router` (declarative routing)
  - `intl` (dates & currency formatting)
  - `mobile_scanner` (QR scanning)
  - `fl_chart` (charts)
  - Dev dependencies: `build_runner`, `drift_dev`, `flutter_lints`
- [x] Set up directory structure according to Section 7 of `PROJECT_PLAN.md`
- [x] Configure Material 3 Theme tokens (`lib/app/theme/`) with light and dark mode
- [x] Create base navigation shell with 5 primary destinations (`lib/app/router.dart`):
  1. Home (Dashboard)
  2. Accounts
  3. Scan (UPI QR)
  4. History
  5. Insights
- [x] Run `flutter analyze` and `flutter test` (0 errors, 0 warnings)

### Phase 1 Checklist (Complete)
- [x] Implement Drift database connection (`lib/core/database/app_database.dart`)
- [x] Define Drift tables (`accounts`, `categories`, `transactions`, `transfers`, `payment_attempts`)
- [x] Run code generation (`dart run build_runner build`)
- [x] Implement ledger balance calculation engine (`lib/data/services/ledger_service_impl.dart`)
- [x] Implement atomic transfer execution service (`lib/data/services/atomic_transfer_service_impl.dart`)
- [x] Write unit & SQLite in-memory integration tests for financial invariants:
  - Balance invariance across transfers
  - Account balance = openingBalance + confirmedIncome - confirmedExpense + transfersIn - transfersOut
  - Unique payment attempt linkage
  - Foreign key and positive paise check constraints

---

## 📝 Key Architecture Decisions Log (ADR)
* **ADR-001 (Money Representation):** All financial values are strictly stored as integer paise (`int`). Example: ₹50.25 is `5025`. No floating-point math allowed for balances.
* **ADR-002 (Payment Confirmation):** Payments initiated via external UPI apps must have an explicit Yes/No user confirmation step upon returning to UFM. No implicit success inference.
* **ADR-003 (Agent Discovery):** `AGENTS.md` and `PROGRESS.md` are kept in the repository root for automatic discovery across chat sessions.
* **ADR-004 (Drift SQLite Foreign Keys & Relational Schema):** Foreign key enforcement is activated via `PRAGMA foreign_keys = ON;` in both connection setup and `beforeOpen`. Schema-level unique constraints and check constraints (`amountPaise > 0`, `source <> dest`) enforce financial integrity at the database layer.

---

## 🔜 Immediate Next Action
Phase 2: Core UI (Accounts list & detail, manual expense/income forms, transfer form, and transaction history views).

