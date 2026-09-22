
# NovaPay Mobile Architecture & Developer Guide

NovaPay is an enterprise-grade, offline-first financial super-app engineered for low-bandwidth environments. This document serves as the comprehensive guide for the system architecture, underlying operational assumptions, and local development configurations.

---

## 🔎 Architecture Overview

NovaPay implements an Offline-First, Serverless Fintech Architecture built on Flutter for the frontend and Firebase for the backend, anchored by a local ACID-compliant persistence layer.


```

[ Flutter UI Layer ]
│
[ Riverpod State Providers ]
│
┌───────┴────────────────────────┐
│                                │
▼                                ▼
[ Drift SQLite Local DB ]     [ Network Connectivity Watcher ]
(Cache & Local Mutation Queue)           │
│                               ▼
└───────────────► [ Sync Engine (Replay Engine) ]
│ (Replays Exactly Once via Idempotency Key)
▼
[ Firebase Cloud Functions ]
(Atomic Transaction Ledger in Firestore)

```

**State & Navigation Management:** Reactive state propagation is managed through Riverpod, while GoRouter handles routing structures and dynamic, state-driven authentication redirects.
* **Local Persistence & Mutation Queue:** Drift (SQLite) enforces local ACID compliance. Transactions initiated in offline or degraded network environments are instantly written to a local queue as pending, indexed by a persistent UUID v4 `idempotencyKey`.
* **Sync Engine & Replay Mechanics:** Network status is continuously monitored via `connectivity_plus`. Upon network restoration, the sync engine executes queued transactions exactly once. If a mutation fails on replay, its status upgrades to `failed` to prevent endless retry loops.
* **Backend Ledger & Idempotency:** Firebase Cloud Functions serve as the compute layer for ledger modifications (`processSendMoney`, `contributeToSave`). Execution occurs within atomic Firestore transactions. Double-spend and double-debit vectors are mitigated by validating the incoming `idempotencyKey` against a dedicated `processed_idempotency_keys` collection.
* **Integer-Based Currency Math:** To completely eliminate floating-point arithmetic errors, all financial figures are processed, stored, and transmitted as 64-bit integers in Kobo. Conversion to Naira (₦XX.XX) is deferred entirely to the UI display layer.

---

## 🌟 Core Features & Modules

### 1. Nova Send (P2P Transfers)
* **Recipient Lookup:** Resolves recipient accounts via 10-digit NIBSS-compliant account numbers.
* **Idempotent Queueing:** Generates an `idempotencyKey` per attempt to guarantee queued sends cannot double-process on reconnection.
* **Biometric Step-Up Authorization:** Triggers hardware biometric authentication (fingerprint/Face ID) for transfers exceeding ₦5,000 (500,000 Kobo).

### 2. Nova Save (Goal-Based Micro-Savings)
* **Goal Creation & Management:** Users create micro-savings targets with a name, target amount in Kobo, and target date.
* **Contribution Flow:** Deducts funds from the main wallet balance and credits the savings goal target atomically.
* **Offline Progress Tracking:** Supports offline contributions queued locally in Drift, displaying progress bars (`currentAmount / targetAmount`) in real-time.

### 3. Local Sync Notifications (Stretch Goal)
* **Replay Alerts:** Integrated via `flutter_local_notifications`. Triggers a local native notification when an offline transaction (`send_money` or `save_contribute`) successfully replays and syncs with the remote Firestore ledger.

### 4. Localization Scaffold (Stretch Goal)
* **Multi-Language Support:** Localized scaffold supporting English (`en`) and Yoruba (`yo`) on the Send Money screen via Flutter `l10n` ARB integration.

---

## ♿ Accessibility & UI Hard Constraints

* **Screen Reader Semantics:** Key interactive controls, transaction tiles, progress bars, and financial amounts are wrapped in `Semantics` widgets with explicit auditory descriptions.
* **Dynamic Font Scaling:** UI containers and text layouts adapt fluidly to system font scaling options (1.0x, 1.5x, 2.0x+) without text clipping, overflow errors, or layout breaks.
* **Lazy List Rendering:** Large datasets (e.g., transaction ledger history) utilize `ListView.builder` for lazy, high-performance widget construction.

---

## 🗒 Key System Assumptions

1. **Identity & Authentication:** Identity verification is handled via Firebase Authentication. A valid user record (`users/{uid}`) must be initialized within Firestore before any transactions can be evaluated.
2. **NIBSS Settlement Simulation:** Recipient lookups simulate the Nigerian Inter-Bank Settlement System (NIBSS) framework locally, mapping against registered Firestore user accounts via 10-digit NIBSS-compliant account numbers.
3. **Single-Attempt Replay Policy:** Due to structural constraints, offline mutations execute a maximum of one replay attempt upon network reconnection. Failed transactions transition to state `failed` for manual user action rather than automated exponential retry loops.
4. **Zero-Trust Backend Validation:** While the client application handles interface validation, Firebase Cloud Functions operate as the single source of truth for authorization, balance checks, and atomic state updates.

---

## 📊 Targeted Environment

* **Flutter SDK Version:** `3.47.4`
* **Dart SDK Version:** `3.10.x` or compatible
* **Target Platforms:** Android (Primary Architecture Target), iOS

---

## ⚡ Getting Started

### Prerequisites

* Verify Flutter SDK `3.47.4` is configured properly in your environment's path variables:
```bash
   flutter --version
```
* Initialize an active Android Virtual Device (AVD) using Android Studio or the Command Line Tools.

<!-- ### Installation & Execution


1. Clone the codebase, resolve dependencies, and deploy the application to your targeted Android environment:

```bash
git clone https://github.com/tindi-plus/novapay
cd novapay
flutter pub get
flutter run

```


2. If multiple environments or virtual devices are detected, list all connected active instances and target the specific emulator:
```bash
# List all active devices
flutter devices

# Target the specified Android emulator instance
flutter run -d emulator-5554

``` -->


### Installation & Execution

You can set up and launch NovaPay automatically using our automated launch script, or manually step-by-step.

#### Option 1: Quick Start (Automated Script)

Run our automated setup script to handle version management, emulator launching, dependency resolution, and application deployment in a single command.

```bash
curl -sSL https://raw.githubusercontent.com/tindi-plus/novapay/main/run_app.sh | bash

```

> **What this script does automatically:**
> 1. **FVM Setup:** Verifies if Flutter Version Management ([FVM](https://fvm.app/?utm_source=gemini)) is installed and installs it globally via `pub` if missing.
> 2. **Flutter Pinning:** Installs and locks the project to **Flutter v3.47.4** locally using FVM.
> 3. **Repository Setup:** Clones the codebase into `./novapay` (if not already present) and switches into the project directory.
> 4. **Emulator Detection & Launch:** Checks for active Android devices via `adb`. If no emulator is running, it automatically boots your default Android Virtual Device (AVD) and waits for system startup to finish.
> 5. **Execution:** Resolves project dependencies (`fvm flutter pub get`) and deploys the app directly to the active emulator (`fvm flutter run`).
> 
> 

---

#### Option 2: Manual Setup

If you prefer to manage your environment manually:

1. **Clone the codebase and navigate into the directory:**
```bash
git clone https://github.com/tindi-plus/novapay
cd novapay

```


2. **Ensure Flutter 3.47.4 is active:**
```bash
fvm install 3.47.4
fvm use 3.47.4

```


3. **Install dependencies and deploy to your running Android device/emulator:**
```bash
fvm flutter pub get
fvm flutter run

```



```

```



### Running Tests

Execute unit, widget, and offline queue integration tests:

```bash
# Run unit and widget tests
flutter test

# Run specific integration tests for offline queue sync
flutter test integration_test/offline_queue_sync_test.dart
```