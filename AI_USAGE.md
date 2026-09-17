# AI Usage Report

## Project

**NovaPay Mobile – Send & Save**

Frontend Engineer (Flutter) Assessment

## Purpose of AI Usage

AI tools were used to accelerate development, architecture design, code scaffolding, documentation, testing strategy design, and review of edge cases. All AI-generated output was reviewed, validated, and modified where necessary before implementation.

The objective was not to blindly accept generated code, but to use AI as an engineering assistant while applying human judgment to ensure correctness, reliability, security, and compliance with the requirements of a fintech application.

---

# AI Tools Used

## ChatGPT / Claude

Used for:

* Solution architecture design
* Offline-first transaction processing design
* Firestore data modeling
* Cloud Function design
* Idempotency strategy
* Accessibility review
* Testing strategy
* Presentation preparation
* Documentation generation

---

## Cline (VS Code)

Used for:

* Flutter code generation
* Riverpod provider scaffolding
* Drift database implementation
* GoRouter configuration
* Form validation implementation
* Firebase Cloud Functions generation
* Widget test scaffolding

---

## GitHub Copilot

Used for:

* Code completion
* Flutter UI scaffolding
* Boilerplate generation
* Refactoring assistance

---

# Example Prompts Used

## Prompt 1 — User Data Model (`lib/src/common/models/`)

Prompt:

> Create a production-ready, immutable User Model in Flutter at `lib/src/common/models/user_model.dart`.
> Requirements:
> 1. Fields: String id (Firebase Auth UID), String firstName, String lastName, String email, String? phoneNumber, String accountNumber (10-digit NIBSS compliant string), String bvn, String nin, int walletBalanceInKobo (stored strictly as integer kobo to prevent floating-point drift), int kycTier (1, 2, or 3), DateTime createdAt, DateTime updatedAt.
> 2. Methods: Include standard `copyWith`, `toMap`, `fromMap` (for Firestore), `toJson`, and `fromJson`. Add a getter `fullName` returning "$firstName$lastName". Add a getter `formattedBalance` that converts `walletBalanceInKobo` to Naira representation (e.g., 20000 kobo -> "₦200.00"). Ensure two decimal places are always displayed.
> 3. Rules: Keep the model pure and immutable with default constructor annotations or free-style Dart `meta` annotations. Do not include external state dependencies or database operations inside this model file.

AI Output:

* Pure immutable Dart `UserModel` class.
* Firestore deserialization logic handling integer kobo mapping.
* Formatted getter ensuring exact two decimal places for Naira display.

Outcome:

Established a type-safe data model enforcing integer kobo representation early in the project.

---

## Prompt 2 — Firebase Auth & User State Management (`lib/src/features/authentication/`)

Prompt:

> Implement the Firebase Authentication and user profile repository layer using Riverpod in Flutter.
> Requirements:
> 1. Create `lib/src/features/authentication/data/auth_repository.dart`: Inject `FirebaseAuth` and `FirebaseFirestore`. Implement `signInWithEmailAndPassword`, `signUpWithEmailAndPassword` (creates Auth user and saves initial `UserModel` record directly into Firestore at `users/{uid}`), `signOut()`, stream getter `authStateChanges`, and `getUserProfile(String uid)`.
> 2. Create `lib/src/features/authentication/providers/auth_providers.dart`: `authStateProvider` listening to `authRepository.authStateChanges`, and `currentUserProfileProvider` fetching `UserModel` from Firestore. Return `AsyncValue<UserModel?>`.

AI Output:

* Authentication repository class wrapping Firebase SDKs.
* Reactive Riverpod providers binding Firebase Auth lifecycle to Firestore user profiles.

Outcome:

Created a clean, decoupled authentication layer supporting seamless session tracking.

---

## Prompt 3 — Router Setup & Auth Guard (`lib/src/routing/`)

Prompt:

> Set up GoRouter with dynamic authentication redirects using Riverpod state.
> Requirements:
> 1. Create `lib/src/routing/app_router.dart`: Define basic route paths: `/login`, `/register`, and `/home`. Build a `GoRouter` instance exposed via a Riverpod provider (`routerProvider`).
> 2. Auth Guard / Redirect Logic: Listen to `authStateProvider`. Implement `redirect` logic: if unauthenticated, redirect to `/login`; if authenticated and accessing login/register, redirect to `/home`. Handle loading states during initial auth check without causing redirect loops. Use `refreshListenable` so GoRouter automatically re-evaluates redirects when auth state updates.

AI Output:

* `GoRouter` setup integrating `Listenable` conversion for Riverpod state changes.
* Dynamic route guard handling unauthenticated access protection and auth redirects.

Outcome:

Guaranteed declarative navigation flow protected against unauthorized route visits.

---

## Prompt 4 — Offline Queue Service & Replay Engine (`lib/src/features/offline_sync/`)

Prompt:

> You are a senior Flutter architect building a production-grade fintech application called Novapay that is offline-first, survives app crashes and restarts, and maintains strict data consistency under patchy network conditions.
> Implement the Background Replay Sync Engine with Connectivity Monitoring in Flutter using Riverpod and Drift.
> Requirements:
> 1. Transaction State Enum: Define a strongly typed enum `TransactionStatus { pending, processing, success, failed }`. Store and retrieve string values in Drift mapping directly to these four allowed states.
> 2. Create `lib/src/features/offline_sync/services/sync_engine.dart`: Use `connectivity_plus` to listen for network state transitions. Inform user when queued due to network issues.
> 3. Replay Logic & Exactly-Once Guarantee: When connectivity returns, fetch items with `status == TransactionStatus.pending`. Update status to `processing`. Call Firebase Cloud Function passing payload and persistent `idempotencyKey`. On success, mark `success` and remove from queue. On failure, update status to `failed`. DO NOT automatically retry or loop again. A queued action is strictly allowed to replay ONLY ONCE.

AI Output:

* Local offline queue system powered by Drift (SQLite).
* Network listener executing background sync with an explicit 4-state lifecycle machine.
* Strict single-replay execution policy preventing infinite loops.

Outcome:

Formed the core offline-first synchronization foundation meeting all hard constraints.

---

# AI Outputs That Were Incorrect or Risky

A key part of using AI effectively is identifying where generated suggestions may introduce risks, especially in financial software.

The following examples illustrate where AI-generated recommendations were intentionally rejected or modified.

---

## Case 1 — Caching Authenticated Users in Drift

### AI Suggestion

Cline generated functionality that cached authenticated user records in the local Drift database after login.

### Why This Was Risky

Although local caching can improve performance, storing user profile information locally creates the possibility of stale identity data.

Examples:

* User account information changes remotely.
* BVN or profile details are updated.
* User records become out of sync with Firestore.

For a financial application, displaying stale customer information may create confusion and operational risks.

### Decision

The local user cache was removed.

User profile information is retrieved directly from Firestore whenever required.

### Lesson

Performance optimizations should not compromise the accuracy of financial identity data.

---

## Case 2 — Client-Side Wallet Updates

### AI Suggestion

Some generated implementations updated account balances directly from the Flutter application.

### Why This Was Risky

A malicious client could potentially manipulate balance updates.

Financial transactions must be processed in a trusted environment.

### Decision

All balance updates are executed exclusively through Firebase Cloud Functions.

The mobile application never directly modifies wallet balances.

Cloud Functions perform:

* Sender validation
* Recipient validation
* Balance checks
* Atomic debit/credit operations
* Transaction record creation
* Idempotency validation

### Lesson

Clients should never be trusted with financial ledger updates.

---

# Human Review Process

Every AI-generated output was reviewed against the following criteria:

## Financial Correctness

* Kobo-only calculations
* No floating-point arithmetic
* Balance validation

## Reliability

* Crash recovery
* Offline persistence
* Replay guarantees

## Security

* Server-side transaction processing
* Authentication protection
* Secure storage usage

## Accessibility

* Semantics support
* Screen reader compatibility
* Text scaling support

## Performance

* ListView.builder usage
* Efficient state management
* Controlled rebuilds

---

# Final Assessment

AI significantly accelerated development of NovaPay by assisting with architecture design, code generation, testing strategy, and documentation.

However, multiple AI-generated suggestions required modification or rejection due to concerns around:

* Financial correctness
* Data consistency
* Security
* Transaction reliability

The final implementation therefore reflects a combination of AI-assisted development and human engineering judgment.

The most valuable outcome of using AI on this project was not the generated code itself, but the ability to rapidly explore design alternatives while maintaining responsibility for the correctness and safety of the final solution.
