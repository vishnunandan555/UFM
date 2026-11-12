# Agent Operating Manual & Project Guidelines

> **Notice to any AI agent working on this repository:**
> Always read this file, `PROJECT_PLAN.md`, and `PROGRESS.md` before making any changes.

---

## 1. Project Mission & Identity
- **Project Name:** UFM (UPI-First Personal Budget Tracker)
- **Framework:** Flutter (Android-first)
- **Role:** Personal finance expense tracker & targeted UPI intent launcher.
- **Strict Boundary:** This app is **NEVER** a bank, payment processor, or wallet. It never handles funds, credentials, or UPI PINs. It does not scrape SMS or notifications.

---

## 2. Immutable Architecture Principles
1. **Integer Paise for Money:**
   - Always store currency as integer paise (`int`). ₹100.50 is stored as `10050`. Never use floating-point numbers (`double`) for currency storage or balances.
2. **Explicit User Confirmation (Yes/No):**
   - App closure does NOT imply payment success.
   - Statuses: `pending`, `confirmed`, `failed`, `unverified`.
   - Only `confirmed` transactions alter account balances.
   - Unanswered attempts remain `unverified` and must be reviewable later.
3. **Ledger as Source of Truth:**
   - Account balance = `openingBalance + confirmedIncome - confirmedExpense + transfersIn - transfersOut`.
   - Transfers between accounts are atomic and do not alter overall balance.
4. **Android Platform Bridge:**
   - Maintain minimum required `<queries>` in `AndroidManifest.xml` (do NOT use `QUERY_ALL_PACKAGES`).
   - Use targeted intents for known supported UPI applications.
5. **Material Design 3 (M3):**
   - Strictly adhere to M3 design tokens (colors, typography, spacing, surface roles).
   - Ensure minimum 48x48 dp touch targets and accessibility contrast.

---

## 3. Workflow for Every Task
Any agent picking up work MUST follow this exact sequence:
1. **Check Progress:** Read `PROGRESS.md` to see the current active phase, completed tasks, and the exact next task.
2. **Consult Spec:** Refer to `PROJECT_PLAN.md` for the technical specifications of that feature.
3. **Implement Incrementally:** Do not generate large unverified batches of code. Implement the single focused task.
4. **Run Verification:**
   - Run `flutter analyze` (must have 0 errors/warnings).
   - Run `flutter test` (all tests must pass).
5. **Update Progress:** Update `PROGRESS.md` marking the task complete, noting any decisions, and updating the "Next Task" pointer.

---

## 4. Directory Structure Reference
```text
lib/
├── app/                  # Theme, router (go_router), root app widget
├── core/
│   ├── database/         # Drift SQLite database, tables, migrations, DAOs
│   ├── errors/           # Failure models and exceptions
│   └── utilities/        # Money formatting, date helpers
├── domain/               # Entities, repository interfaces, value objects
├── data/                 # Repository implementations, data sources
├── features/
│   ├── dashboard/        # Period summaries, balance view
│   ├── accounts/         # Account management, opening balance
│   ├── transactions/     # Manual expense/income forms & ledger
│   ├── categories/       # Category management & seed data
│   ├── history/          # Unified transaction search & filters
│   ├── insights/         # Monthly breakdown & basic charts
│   └── upi/              # QR scanner, URI parser, app selector, intent launcher
└── main.dart
```

---

## 5. Testing Requirements
- Unit tests for money math, balance formulas, and URI parsing.
- In-memory SQLite tests for database tables, foreign keys, and atomic transfers.
- Flutter widget tests for forms, validations, and confirmation dialogs.
- `fake_upi_app` Android companion app for intent & lifecycle integration testing.

