## NovaPay Mobile Architecture & Developer Guide
NovaPay is an enterprise-grade, offline-first financial super-app engineered for low-bandwidth environments. This document serves as the comprehensive guide for the system architecture, underlying operational assumptions, and local development configurations.
------------------------------
## 🔎 Architecture Overview
NovaPay implements an Offline-First, Serverless Fintech Architecture built on Flutter for the frontend and Firebase for the backend, anchored by a local ACID-compliant persistence layer.

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


* State & Navigation Management: Reactive state propagation is managed through Riverpod, while GoRouter handles routing structures and dynamic, state-driven authentication redirects.
* Local Persistence & Mutation Queue: Drift (SQLite) enforces local ACID compliance. Transactions initiated in offline or degraded network environments are instantly written to a local queue as pending, indexed by a persistent UUID v4 idempotencyKey.
* Sync Engine & Replay Mechanics: Network status is continuously monitored via connectivity_plus. Upon network restoration, the sync engine executes queued transactions exactly once. If a mutation fails on replay, its status upgrades to failed to prevent endless retry loops.
* Backend Ledger & Idempotency: Firebase Cloud Functions serve as the compute layer for ledger modifications (e.g., processSendMoney, contributeToSave). Execution occurs within atomic Firestore transactions. Double-spend and double-debit vectors are mitigated by validating the incoming idempotencyKey against a dedicated processed_idempotency_keys collection.
* Integer-Based Currency Math: To completely eliminate floating-point arithmetic errors, all financial figures are processed, stored, and transmitted as 64-bit integers in Kobo. Conversion to Naira (₦XX.XX) is deferred entirely to the UI display layer.

------------------------------
## 🗒 Key System Assumptions

   1. Identity & Authentication: Identity verification is handled via Firebase Authentication. A valid user record (users/{uid}) must be initialized within Firestore before any transactions can be evaluated.
   2. NIBSS Settlement Simulation: Recipient lookups simulate the Nigerian Inter-Bank Settlement System (NIBSS) framework locally, mapping against registered Firestore user accounts via 10-digit NIBSS-compliant account numbers.
   3. Single-Attempt Replay Policy: Due to structural constraints, offline mutations execute a maximum of one replay attempt upon network reconnection. Failed transactions are flagged for manual user intervention rather than automated exponential backoff.
   4. Zero-Trust Backend Validation: While the client application handles interface validation, Firebase Cloud Functions operate as the single source of truth for authorization, balance checks, and atomic state updates.

------------------------------
## 📊 Targeted Environment

* Flutter SDK Version: 3.47.4
* Dart SDK Version: 3.10.x or compatible
* Target Platforms: Android (Primary Architecture Target), iOS

------------------------------
## ⚡ Getting Started## Prerequisites

* Verify Flutter SDK 3.47.4 is configured properly in your environment's path variables.
* Initialize an active Android Virtual Device (AVD) using Android Studio or the Command Line Tools.

## Installation & Execution
Clone the codebase, resolve dependencies, and deploy the application to your targeted Android environment:

git clone <repository-url>
cd novapay
flutter pub get
flutter run

If multiple environments or virtual devices are detected, list all connected active instances and target the specific emulator:

# List all active devices
flutter devices
# Target the specified Android emulator instance
flutter run -d emulator-5554
