# UFM Project Progress & State Tracker

> **Single Source of Truth for Agents & Developers**  
> Last updated: 2026-11-12 (Phase 4 Milestone 1 complete)

---

## 📌 Overall Project Status

| Phase | Description | Status | Completion % |
| :--- | :--- | :--- | :--- |
| **Phase 0** | Project Bootstrap (Flutter, Theme, Navigation Shell, CI/Lint) | ✅ Completed | 100% |
| **Phase 1** | Financial Foundation (Drift DB, Schema, Ledger, Transfers) | ✅ Completed | 100% |
| **Phase 2** | Core UI (Accounts, Income/Expense, Transfer, History) | ✅ Completed | 100% |
| **Phase 3** | Scanner & UPI URI Parser (Fixtures, QR review screen) | ✅ Completed | 100% |
| **Phase 4** | App Discovery, Intent Launch & Fake UPI Test App | ✅ Completed | 100% |
| **Phase 5** | Payment Lifecycle (Yes/No Dialog, State Recovery, Ledger linkage) | ⏳ Next | 0% |
| **Phase 6** | Summaries, Polish, Backup/Restore, Real-device verification | ⚪ Not Started | 0% |

---

## 🎯 Current Focus: Phase 5 — Payment Lifecycle (Pre-launch, Confirmation, Recovery & Ledger Linkage)

### Phase 4 Checklist (Complete)

- [x] Build standalone `fake_upi_app` Android companion app (`com.ufm.fakeupi`) for deterministic emulator testing
- [x] Configure AGP 9.1.0, Kotlin 2.4.0, Gradle 9.3.1 build scripts in `fake_upi_app/` and verify `./gradlew assembleDebug`
- [x] Implement NPCI `upi://pay` deep-link filter, parameters inspection, and 4 simulation buttons (Success, Failure, Cancel, Kill/Crash) in `FakeUpiApp`
- [x] Configure minimal `<queries>` in UFM's `AndroidManifest.xml` with generic `upi://pay` intent and 9 whitelisted packages (no `QUERY_ALL_PACKAGES`)
- [x] Implement Kotlin Android platform channel bridge (`UpiIntegration.kt` & `MainActivity.kt`) for `com.ufm.tracker.ufm/upi`
- [x] Implement Dart platform bridge (`UpiPlatform`, `InstalledUpiApp`, `UpiLaunchResult`, `MethodChannelUpiPlatform`, and Riverpod `upiPlatformProvider`)
- [x] Implement pure Dart NPCI URI builder utility (`UpiUriBuilder`) using strict integer paise arithmetic
- [x] Implement preferred UPI app persistence (`PreferredUpiAppService` with file and in-memory test implementations)
- [x] Implement Material 3 App Selector bottom sheet (`AppSelectorSheet`) with >= 48dp touch targets, test app badge, preferred app indicator, and empty state
- [x] Wire up `QrReviewScreen` with app discovery, selector sheet, pre-launch persistence, and targeted intent launch
- [x] Add comprehensive unit and widget tests (96/96 passing tests, 0 analyzer issues, adversarial challenger hardening complete)
- [x] Verify compilation of Android host app debug APK (`flutter build apk --debug`) and companion app debug APK (`./gradlew assembleDebug`)

---

## 📝 Key Architecture Decisions Log (ADR)

* **ADR-001 (Money Representation):** All financial values are strictly stored as integer paise (`int`). Example: ₹50.25 is `5025`. No floating-point math allowed for balances.
- **ADR-002 (Payment Confirmation):** Payments initiated via external UPI apps must have an explicit Yes/No user confirmation step upon returning to UFM. No implicit success inference.
- **ADR-003 (Agent Discovery):** `AGENTS.md` and `PROGRESS.md` are kept in the repository root for automatic discovery across chat sessions.
- **ADR-004 (Drift SQLite Foreign Keys & Relational Schema):** Foreign key enforcement is activated via `PRAGMA foreign_keys = ON;` in both connection setup and `beforeOpen`. Schema-level unique constraints and check constraints (`amountPaise > 0`, `source <> dest`) enforce financial integrity at the database layer.
- **ADR-005 (Material 3 Core UI & Unified History):** Navigation uses a 5-tab M3 navigation bar. Dashboard provides live confirmed balances and quick entry dialogs. History unifies confirmed transactions, transfers, and unverified payment attempts with in-place resolution.
- **ADR-006 (Strict UPI URI Validation & Payee Inspection):** QR payloads are parsed with `Uri.parse` and validated against VPA format, INR currency, and positive paise. Fixed amounts are displayed locked; variable amounts require user entry.
- **ADR-007 (Targeted UPI Intent Resolution & Package Whitelisting):** Device UPI applications are discovered and launched via a native Kotlin MethodChannel (`com.ufm.tracker.ufm/upi`) using fine-grained Android `<queries>` declarations without `QUERY_ALL_PACKAGES`. Target apps are matched against NPCI standards and whitelisted package IDs. Pre-launch attempts are strictly persisted in Drift SQLite before intent activation.

---

## 🔜 Immediate Next Action

Phase 5: Payment Lifecycle — Pre-launch attempt persistence, explicit post-launch Yes/No confirmation dialog, 1-to-1 ledger linkage to confirmed expense transactions, app resume/process death recovery of unverified attempts, and funding account correction flow.
