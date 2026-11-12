# UPI-First Personal Budget Tracker --- Build Plan

**Status:** Implementation baseline\
**Platform:** Android-first\
**Framework:** Flutter\
**Purpose:** Maintain multiple money accounts, initiate UPI payments
through installed UPI apps, and unify confirmed/manual transactions in
one local ledger.

## 1. Product vision

Build a minimal, privacy-first personal finance app. Users can: -
Maintain bank, cash and other accounts with opening balances. - Record
expenses, income and transfers. - Scan merchant UPI QR codes inside the
app. - Review merchant and payment details, add a category/note, select
an installed UPI app and launch payment. - Return to the tracker and
explicitly confirm whether payment succeeded. - View UPI-originated and
manually entered transactions in one history.

This app is an **expense tracker and UPI intent launcher**, not a bank,
wallet, payment processor or UPI provider. It never handles funds, UPI
PINs or banking credentials.

### Principles

-   Offline-first and local-first.
-   No login, backend or cloud requirement in v1.
-   One ledger for all income, expenses and transfers.
-   Explicit user confirmation; never infer payment success because an
    external app closed.
-   Unverified and failed attempts do not affect confirmed balances.
-   Avoid premature abstractions and unnecessary features.

## 2. Version 1 scope

### Included

-   Multiple accounts: bank, cash and generic.
-   Opening balances and calculated current balances.
-   Income, expenses and transfers.
-   Built-in and user-created categories.
-   Optional merchant, note and tags.
-   UPI QR scanning and URI parsing.
-   Detection of supported installed UPI applications.
-   In-app UPI application selector and preferred app.
-   Targeted UPI intent launch.
-   Yes/No payment confirmation; unanswered attempts remain unverified.
-   Unified history, basic search and filters.
-   Monthly income/expense summaries and basic category totals.
-   Local backup/export and restore/import.

### Explicitly excluded from v1

-   Bank account aggregation or automatic balance retrieval.
-   Reading private transaction histories from Google Pay, BHIM, PhonePe
    or other apps.
-   SMS/notification scraping.
-   Automatic bank/PSP payment verification.
-   Payment gateway or handling funds.
-   Cloud accounts, sync or shared household budgets.
-   Investment, credit-score or loan tracking.
-   AI categorisation.
-   iOS payment integration.
-   Multiple currencies.

## 3. Core user flows

### First launch

1.  Create an account, e.g. SBI Savings.
2.  Select account type and enter opening balance.
3.  Optionally add Cash or another account.
4.  Open dashboard.

No sign-in, internet or bank credentials required.

### Manual expense/income

1.  Choose Expense or Income.
2.  Enter positive amount, account, category and optional
    merchant/note/date/tags.
3.  Save.
4.  Recalculate the account balance from the ledger.

### Transfer

1.  Select source and destination accounts.
2.  Enter positive amount, date and optional note.
3.  Validate that accounts differ.
4.  Save both sides atomically.

A transfer is neither income nor expense. Combined balances must remain
unchanged.

### UPI QR payment

1.  Open scanner and scan QR.
2.  Validate supported UPI payment URI.
3.  Extract available payee details and amount.
4.  Display payee name and VPA for user inspection.
5.  If QR has no amount, require amount entry. If it supplies an amount,
    display it and do not silently overwrite it.
6.  Choose category, intended account and optional note.
7.  Select a compatible installed UPI app within our app.
8.  Persist a pending payment attempt **before** launching external app.
9.  Launch selected app with a targeted UPI intent.
10. On return, ask: **"Was the payment successful?"** with Yes and No.
11. Yes → user-confirmed expense. No → failed attempt. No
    answer/dismissal → unverified attempt.
12. Allow unresolved attempts to be reviewed later.

If app launch fails, show a recovery action. If the user cancels or
returns without answering, do not mark failed. Never automatically retry
a payment with an uncertain outcome.

## 4. Payment status and account rules

Use these states:

  Status         Meaning                                    Included in confirmed balance?
  -------------- ---------------------------------------- --------------------------------
  `pending`      Attempt created; outcome not resolved                                  No
  `confirmed`    User explicitly selected Yes                              Yes, as expense
  `failed`       User explicitly selected No                                            No
  `unverified`   User did not answer or outcome unknown                                 No

**Yes means user-confirmed, not bank-verified.** No response is not
failure. Unverified attempts remain reviewable. Confirmation must create
exactly one ledger transaction.

Store separately: - `intendedAccountId`: account user intended to debit
in tracker. - `actualFundingAccountId`: optional account user confirms
was actually selected inside UPI app.

The tracker cannot assume the selected account in its own form is the
account ultimately used inside Google Pay or another UPI app. Let user
correct the account before finalising the ledger entry.

Record the UPI app selected and launched. Do not claim this proves which
app ultimately processed the payment if the user switches apps or the
flow is interrupted.

## 5. Technology stack

  -----------------------------------------------------------------------
  Layer                   Choice                  Purpose
  ----------------------- ----------------------- -----------------------
  UI/application          Flutter                 Android-first, portable
                                                  non-platform code

  Language                Dart                    UI, domain and
                                                  application logic

  Android bridge          Kotlin                  Package visibility,
                                                  targeted intents,
                                                  lifecycle

  Local DB                Drift + SQLite          Typed schema,
                                                  migrations,
                                                  transactions

  State                   Riverpod                Feature state and
                                                  dependency wiring

  Navigation              go_router               Declarative navigation

  QR scanner              `mobile_scanner`        Camera scanning

  Charts                  `fl_chart`              Basic summaries

  Formatting              `intl`                  Locale-aware
                                                  dates/numbers

  Tests                   `flutter_test`          Unit/widget tests

  Native tests            Android instrumentation Android behaviour
                          / Flutter integration   
                          tests                   
  -----------------------------------------------------------------------

Check package maintenance, licence, compatibility and current versions
before adding dependencies. Do not invent or pin unverified versions in
this plan. Commit the application lockfile.

Keep UPI behind a small platform interface, for example:

``` dart
abstract interface class UpiPlatform {
  Future<List<InstalledUpiApp>> getCompatibleApps();

  Future<UpiLaunchResult> launchPayment({
    required String packageName,
    required String paymentUri,
  });
}
```

Do not expose Android package APIs throughout Dart code.

## 6. UI/UX design direction

### Primary design skill

Use **Material Design 3 UI/UX** as the primary design skill for the
coding agent:

-   [Material Design 3 UI/UX Skill ---
    SKILL.md](https://github.com/skydashnet/material-design-3-ui-skill/blob/main/SKILL.md)
-   [Skill
    repository](https://github.com/skydashnet/material-design-3-ui-skill)
-   [Official Material Design 3](https://m3.material.io/)
-   [Flutter accessibility and UI
    styling](https://docs.flutter.dev/ui/accessibility/ui-design-and-styling)

This is a good fit for Android-first Flutter. It treats Material 3 as an
interaction, hierarchy, state and accessibility system---not merely
rounded cards and colours. The skill is agent guidance, not a runtime
package. Install/reference it using the coding agent's supported Agent
Skills mechanism; otherwise follow this section directly.

### Visual direction

Create a minimal, calm, premium-feeling finance interface: - Strong
information hierarchy; balances and spending summaries readable at a
glance. - Restrained accent colour; semantic colours for income,
expenses, warnings and payment states. - Neutral surfaces and clear
typography. - Use whitespace and alignment rather than enclosing every
section in a card. - Avoid excessive gradients, shadows, decorative
illustrations and oversized rounded containers. - Use icons with labels
where meaning may be unclear. - Consistent spacing, typography, shape
and colour tokens. - Light and dark themes. - Focused, fast scan/payment
flow. - Native-feeling Android navigation and interaction patterns.

Do not copy another finance app pixel-for-pixel. Use established
patterns without imitating a brand.

### Design system

Define semantic tokens before screen styling: - Colour roles:
background, surface, surface variant, primary, secondary, outline,
error, success and warning. - Typography: balance, screen title, section
title, body, label, caption and numeric amount. - Consistent spacing
scale and restrained shape scale. - Minimal purposeful elevation. - One
consistent icon family. - Brief functional motion; respect
reduced-motion settings.

Avoid scattered literal colour and spacing values.

### Accessibility

-   Minimum Android touch target: 48 × 48 dp.
-   Adequate contrast; never use colour alone for state.
-   Support system font scaling without clipping.
-   Semantic labels for icon-only controls.
-   TalkBack and logical focus order.
-   Respect system insets, keyboard and system bars.
-   Test compact screens and enlarged text.
-   Clear errors and recovery actions.

### Navigation

Keep five primary destinations: 1. **Home:** confirmed total balance,
period summary and recent transactions. 2. **Accounts:** accounts,
balances, account management and transfers. 3. **Scan:** central UPI QR
entry point. 4. **History:** unified transaction list, search and
filters. 5. **Insights:** basic category and monthly summaries.

Manual income/expense entry must be available without scanning. Do not
fill the dashboard with unnecessary charts.

## 7. Architecture and project structure

Use a lightweight layered, feature-oriented architecture:

``` text
lib/
├── app/
│   ├── app.dart
│   ├── router.dart
│   └── theme/
├── core/
│   ├── database/
│   │   ├── app_database.dart
│   │   ├── tables/
│   │   └── migrations/
│   ├── errors/
│   └── utilities/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── services/
├── data/
│   ├── repositories/
│   └── models/
├── features/
│   ├── dashboard/
│   ├── accounts/
│   ├── transactions/
│   ├── categories/
│   ├── history/
│   ├── insights/
│   └── upi/
│       ├── scanner/
│       ├── parser/
│       ├── app_selector/
│       ├── launcher/
│       └── confirmation/
└── main.dart

android/
└── app/src/main/
    └── kotlin/.../UpiIntegration.kt

test/
├── unit/
├── widget/
├── integration/
└── fixtures/
```

Do not create empty folders or abstractions for hypothetical future
features. Add them when needed.

## 8. Database design

Use Drift/SQLite with versioned migrations from the first schema.

### Money

Store monetary values as integer paise, never floating point: - ₹150.00
= `15000` - ₹150.75 = `15075`

INR only in v1.

### Tables

#### `accounts`

-   `id`
-   `name`
-   `type` (`bank`, `cash`, `other`)
-   `openingBalancePaise`
-   `createdAt`, `updatedAt`
-   `isArchived`
-   Optional `iconKey`, `colourKey`

Do not store banking credentials or UPI PINs.

#### `categories`

-   `id`
-   `name`
-   `kind` (`expense`, `income`, `both`)
-   `iconKey`
-   `isDefault`, `isArchived`
-   `createdAt`

Seed a small useful set; allow user-created categories.

#### `transactions`

-   `id`
-   `accountId`
-   `type` (`expense`, `income`)
-   `amountPaise`
-   nullable `categoryId`
-   `merchant`, `note`
-   `occurredAt`, `createdAt`, `updatedAt`
-   `source` (`manual`, `upi_qr`, etc.)
-   `paymentMethod` (`cash`, `upi`, `other`)
-   nullable `paymentAppId`
-   nullable `actualFundingAccountId`
-   nullable `paymentAttemptId`
-   nullable `externalReference`
-   correction/reversal linkage if implemented

Use foreign keys and indexes. Use IDs, not merchant names, as
relationships.

#### `transfers`

-   `id`
-   `sourceAccountId`
-   `destinationAccountId`
-   `amountPaise`
-   `occurredAt`
-   `note`
-   `createdAt`

Transfers update both account views atomically and are excluded from
ordinary income/expense totals.

#### `payment_attempts`

-   `id`
-   `status`
-   `payeeName`, `payeeVpa`
-   `amountPaise`
-   `amountWasProvidedByQr`
-   `rawQrPayload` or safely retained parsed fields
-   `categoryId`, `note`
-   `intendedAccountId`
-   nullable `actualFundingAccountId`
-   `selectedPaymentAppId`
-   nullable `externalReference`
-   `createdAt`, nullable `launchedAt`, nullable `resolvedAt`
-   nullable `linkedTransactionId` (unique when present)
-   nullable `launchError`

Avoid retaining sensitive QR data longer than needed. Define deletion
and export behaviour.

Add `tags` and `transaction_tags` only if free-form tags are included in
v1; categories alone are sufficient for the first usable release.

### Balance calculation

The ledger is the source of truth:

``` text
Current balance =
    Opening balance
  + Confirmed income
  - Confirmed expenses
  + Transfers in
  - Transfers out
```

Pending, failed and unverified attempts do not affect confirmed
balances. A cached balance may be added later, but it must be
rebuildable from ledger entries.

Use database transactions for: - Transfers. - Confirming a UPI payment
and creating its expense. - Reversal/correction operations. - Backup
import.

A payment attempt must link to at most one ledger transaction. Enforce
duplicate prevention in the database, not only in UI state.

## 9. UPI integration details

### QR parsing

Support UPI payment URIs commonly beginning with `upi://pay`. Parse
known fields: - `pa`: payee VPA. - `pn`: payee name. - `am`: amount, if
supplied. - `cu`: currency. - `tn`: note. - `tr`: reference, if
supplied. - `mc`: merchant category code, if supplied.

Rules: - Use a URI parser, not manual string splitting. - Handle
percent-encoding. - Validate required fields and amount format. - Reject
unsupported schemes and malformed payloads safely. - Do not trust QR
merchant name as verified identity. - Display VPA for inspection. -
Preserve a QR-supplied amount; require entry when absent. - Do not
assume every QR is a UPI payment QR. - Maintain fixtures for valid,
invalid, encoded and edge-case payloads.

### Installed app discovery

Implement discovery in Kotlin. Android 11+ package visibility
restrictions apply. Declare minimum required `<queries>` entries in
`AndroidManifest.xml`. Do not request `QUERY_ALL_PACKAGES` merely to
find payment apps.

Distinguish: - Package installed. - Package visible to our app. -
Package resolves the required UPI intent. - Integration is tested and
supported.

An installed app is not automatically a compatible app.

### Compatibility registry

Maintain a small registry of individually tested integrations. Each
entry should contain: - Stable internal app ID. - Android package
name. - Display name. - Integration status/version. - Supported launch
behaviour. - Tested URI/intent variations. - Known limitations.

Only include apps whose package identity and launch behaviour have been
verified on a real or controlled test device. Do not rely on display
names as package identifiers. Revalidate integrations when app versions
change.

Allow preferred-app selection. If unavailable or incompatible, offer
another supported app with a clear explanation.

### Targeted launch

Construct a valid UPI payment URI from validated QR data and
user-entered details. Explicitly target the selected app by package
where supported; do not show the generic Android chooser as the normal
selection UI.

The external UPI app handles its own payment confirmation, funding
account selection, authentication and payment. Never collect UPI PINs.

Do not assume all apps return identical activity results or transaction
metadata. Treat returned data as optional and non-authoritative unless
independently verified through a suitable provider integration.

### Lifecycle and recovery

-   Persist attempt before launch.
-   Do not depend on Flutter process remaining alive.
-   On resume, locate unresolved attempts and show recovery/confirmation
    UI.
-   Handle cancellation, no result, launch exceptions and process
    recreation.
-   Never automatically relaunch an uncertain payment.
-   Prevent duplicate attempts/ledger entries on repeated callbacks or
    resume events.

## 10. Feature requirements

### Accounts

-   Create, edit, archive and view accounts.
-   Set opening balance.
-   Display calculated current balance.
-   Handle archiving accounts with unresolved transactions explicitly.
-   Support multiple bank and cash accounts.
-   No bank connectivity in v1.

### Transactions

-   Add, edit and view income/expenses.
-   Require positive amount and account.
-   Optional category, merchant, note, date and tags.
-   Filter by date, account, category and type.
-   Prevent accidental duplicate saves.
-   Use controlled correction/reversal flow for financial history.

### Transfers

-   Require distinct source/destination accounts and positive amount.
-   Save both sides atomically.
-   Exclude from income/expense totals.
-   Show direction clearly in account history.

### UPI

-   Scan and parse QR.
-   Show merchant details and amount.
-   Capture category, intended account and optional note.
-   Select compatible installed app inside tracker.
-   Launch targeted intent.
-   Ask Yes/No after return.
-   Keep unanswered attempts unverified.
-   Allow later review.
-   Record selected app.
-   Allow user-confirmed correction of actual funding account.

### History and summaries

-   Unified manual and UPI history.
-   Distinguish confirmed transactions from unresolved attempts.
-   Separate income, expense and transfer.
-   Monthly confirmed income/expense totals.
-   Category totals based only on committed ledger entries.
-   Do not include pending/unverified attempts in confirmed spending
    totals.

## 11. Testing strategy

### Unit tests --- no device or real payment

-   Money parsing/formatting and paise arithmetic.
-   Opening balances.
-   Income/expense calculations.
-   Transfers and combined-balance invariance.
-   Category totals and date filters.
-   UPI URI parsing, decoding and malformed payloads.
-   Amount validation.
-   Payment state transitions.
-   Duplicate confirmation prevention.
-   Backup validation.

### Database tests

-   Fresh database and every migration.
-   Foreign-key constraints.
-   Atomic transfers.
-   Atomic payment confirmation and ledger insertion.
-   Unique attempt-to-transaction linkage.
-   Rebuilding balances from ledger.
-   Backup round-trip and corrupted backup handling.

### Widget tests

-   Account creation/editing.
-   Manual expense/income forms.
-   Transfer validation.
-   QR review screen.
-   App selector.
-   Yes/No confirmation.
-   Unverified payment list.
-   History filters and empty states.
-   Light/dark theme.
-   Large text and semantics.

### Android integration tests

Use emulator and at least one physical Android device: - Camera
permission granted/denied. - QR scanner and camera lifecycle. - Package
visibility and app detection. - Targeted intent launch. -
Missing/incompatible app. - User cancellation. - Returning from external
app. - Process death/recovery. - Duplicate lifecycle callbacks.

### Fake UPI test app

Build a development-only Android app that registers for the required
payment intent and can display received URI fields and simulate success,
failure, cancellation and no result. This enables repeatable tests
without real payments. Clearly mark it as a test app; never ship it as a
payment provider.

### Real-device tests

Only after automated/fake-app tests pass: - Controlled low-value
payments. - Fixed-amount and variable-amount QR fixtures. - Each
supported UPI app/version. - Verify selected-app attribution. - Verify
funding-account correction. - Verify unanswered payments remain
unverified. - Never claim bank-level automatic verification.

### Minimum acceptance cases

  Scenario                         Expected result
  -------------------------------- -----------------------------------------
  Add ₹100 expense                 Confirmed balance decreases ₹100
  Add ₹500 income                  Confirmed balance increases ₹500
  Transfer ₹200                    Combined balance unchanged
  Failed UPI attempt               No expense
  Unanswered prompt                Unverified; no confirmed balance change
  User confirms success            Exactly one expense
  Repeated callback/resume         No duplicate expense
  App killed during payment        Attempt survives
  QR has fixed amount              Amount displayed, not silently changed
  QR has no amount                 User must enter amount
  UPI app unavailable              No launch; recovery shown
  Different funding account used   Allow account correction

## 12. Implementation roadmap

Implement one phase at a time. Each phase must compile, pass relevant
tests and be reviewed before proceeding.

### Phase 0 --- Bootstrap

-   Create Flutter project.
-   Configure Android application ID and minimum supported Android
    version.
-   Verify dependencies and Android build configuration.
-   Set up linting and formatting.
-   Set up Material 3 theme tokens and navigation shell.
-   Add CI for formatting, analysis and tests.
-   Create README and architecture notes.

**Exit:** Clean build; CI runs; no feature logic yet.

### Phase 1 --- Financial foundation

-   Drift and initial schema.
-   Migrations.
-   Accounts and categories.
-   Income and expense transactions.
-   Transfers.
-   Balance calculation.
-   Ledger tests.

**Exit:** User can manage bank/cash accounts and manually record money
movement. Balance and transfer tests pass.

### Phase 2 --- Basic app UI

-   Dashboard.
-   Accounts list/detail and account form.
-   Manual income/expense forms.
-   Transfer form.
-   Transaction history.
-   Basic filters/categories.
-   Light/dark themes and accessibility checks.

**Exit:** Useful offline tracker works without UPI.

### Phase 3 --- Scanner and parser

-   Camera scanner.
-   UPI URI parser and fixtures.
-   Merchant/amount review screen.
-   Invalid/unsupported QR handling.

**Exit:** Scanning produces a validated payment draft; no external
launch yet.

### Phase 4 --- App discovery and launch

-   Kotlin platform bridge.
-   Minimal package visibility declarations.
-   Tested app registry.
-   Installed compatible-app detection.
-   Internal selector and preferred-app setting.
-   Targeted intent launch.
-   Fake UPI test app.

**Exit:** Payment draft launches selected test app and supported real
apps on test devices.

### Phase 5 --- Payment lifecycle

-   Persist attempts before launch.
-   Pending/confirmed/failed/unverified states.
-   Yes/No confirmation UI.
-   Resume/process-death recovery.
-   Link confirmed attempts to one expense.
-   Duplicate prevention.
-   Later review of unverified attempts.
-   Intended/actual account correction.

**Exit:** Lifecycle tests pass, including cancellation, unanswered
prompts and process death.

### Phase 6 --- Summaries and release

-   Monthly income/expense summary.
-   Category totals/basic charts.
-   Search and filters.
-   Backup/export and restore/import.
-   Accessibility and visual QA.
-   Migration QA.
-   Physical-device compatibility testing.
-   Release build and store preparation.

**Exit:** Reliable Android v1 with documented supported UPI apps and
limitations.

## 13. Coding-agent workflow

The agent must work incrementally, not generate the entire application
in one pass.

For each task: 1. Read this plan and relevant project files. 2. Identify
phase and acceptance criteria. 3. Inspect current architecture before
changes. 4. Propose a small implementation plan. 5. Implement only the
requested task/phase. 6. Add/update tests. 7. Run formatter, static
analysis and relevant tests. 8. Fix failures; do not suppress them
without justification. 9. Review diff for unrelated changes, duplication
and unnecessary abstractions. 10. Update documentation/checklist. 11.
Report files changed, tests run, results and limitations.

### Required practices

-   Follow Dart analysis/lint rules.
-   Keep widgets focused on presentation.
-   Keep financial rules out of widgets.
-   Keep database access behind repositories.
-   Use explicit error types and recovery messages.
-   Use database transactions for multi-record financial operations.
-   Use stable IDs; do not identify transactions by merchant and amount
    alone.
-   Avoid global mutable state and premature frameworks.
-   Do not add a backend without an approved requirement.
-   Do not store secrets in source control.
-   Never log UPI PINs, credentials or unnecessary raw financial data.
-   Never claim tests passed unless they were run and inspected.

### Definition of done

A feature is complete only when acceptance criteria are met, business
logic is tested, relevant UI states are handled, offline behaviour is
correct, accessibility/theme requirements are met, balances cannot be
corrupted or duplicated, analysis/tests pass and limitations are
documented.

## 14. Risks and decisions to verify

  -----------------------------------------------------------------------
  Risk                                Required action
  ----------------------------------- -----------------------------------
  UPI apps differ in intent handling  Test each app individually;
                                      maintain registry

  Android package visibility          Declare minimum `<queries>` and
                                      test current Android versions

  Activity results differ             Treat callback metadata as
                                      optional; ask user

  Different bank account used         Store intended and actual funding
                                      account separately

  Android kills tracker               Persist attempt before launch;
                                      recover on resume

  QR formats vary                     Maintain fixtures; reject
                                      unsupported formats

  Package/behaviour changes           Revalidate registry on integration
                                      updates

  Incorrect user confirmation         Make status visible; provide
                                      correction flow

  Inconsistent totals                 Derive balances from ledger and
                                      test invariants

  UI becomes noisy                    Follow restrained Material 3 tokens
                                      and hierarchy
  -----------------------------------------------------------------------

## 15. Future expansion --- not v1

-   Optional encrypted backup improvements.
-   Optional cloud sync.
-   Recurring transactions.
-   Advanced budgets and alerts.
-   CSV import/export.
-   User-provided bank statement import.
-   Reconciliation tools.
-   Non-payment platform support.
-   Shared accounts/household budgets.

Future features must preserve the single-ledger model and local-first
operation.

## 16. First task for the coding agent

**Do not start with UPI.** Begin with Phase 0 and Phase 1:

1.  Inspect repository and Flutter/Dart environment.
2.  Create/initialise Flutter project if needed.
3.  Verify package compatibility and Android build configuration.
4.  Set up Material 3 design system and minimal navigation shell.
5.  Implement Drift schema, migrations and repositories for accounts,
    categories, transactions and transfers.
6.  Implement balance calculations and ledger invariants.
7.  Add unit and database tests.
8.  Stop after Phase 1 and report results before Phase 2.

The first milestone is a correct offline financial ledger. UPI is an
input method integrated into that ledger later, not a separate expense
database.

## 17. Reference documentation

### Design

-   [Material Design 3 UI/UX Agent
    Skill](https://github.com/skydashnet/material-design-3-ui-skill/blob/main/SKILL.md)
-   [Material Design 3](https://m3.material.io/)
-   [Flutter accessibility and UI
    styling](https://docs.flutter.dev/ui/accessibility/ui-design-and-styling)

### Flutter

-   [Flutter documentation](https://docs.flutter.dev/)
-   [Flutter app
    architecture](https://docs.flutter.dev/app-architecture)
-   [Flutter testing](https://docs.flutter.dev/testing)

### Android and UPI

-   [Android package
    visibility](https://developer.android.com/training/package-visibility)
-   [Android
    intents](https://developer.android.com/guide/components/intents-filters)
-   [Google Pay UPI integration
    documentation](https://developers.google.com/pay/india/api/android/in-app-payments)
-   [NPCI](https://www.npci.org.in/)

### Local data

-   [Drift documentation](https://drift.simonbinder.eu/)
-   [SQLite documentation](https://www.sqlite.org/docs.html)

------------------------------------------------------------------------

**End of build plan.**
