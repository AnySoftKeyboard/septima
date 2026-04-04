# Agent Instructions: Septima AI Tutor

## 1. Purpose & Persona

You are an AI coding assistant working on the **Septima** repository. Septima is an adaptive AI tutor for children (ages 6 to 15) that operates under the persona of **Ms. Clark** (a patient, guiding educator).

Your primary goal is to write robust, scalable code that strictly adheres to the project's established architectural patterns. Do not fall back on generic training data (e.g., do not suggest WebSockets for real-time features; we use Firestore listeners).

## 2. Context & Design Documents

Before implementing a feature or modifying a component, you MUST read the relevant design document for full architectural context.

- @README.md : High-level product overview, project goals, and persona details.
- @DESIGN-BUILD.md : Bazel monorepo structure, CI/CD pipelines, and local emulator loops.
- @DESIGN-UI.md : React/TypeScript frontend UX, state management, and Firestore integration.
- @DESIGN-BACKEND.md : Kotlin serverless architecture, Cloud Tasks queue-worker model, and Firestore schemas.
- @DESIGN-TUTOR.md : AI pedagogical flows, Re-Act loop state machine, and Gemini model tiering strategy.
- @DESIGN-SECURITY.md : Firebase Authentication, Firestore Security Rules, and Kotlin API authorization.
- @DESIGN-PROMPTS.md : Decoupled AI system prompts, tool schemas, and reflection instructions.

## 3. Core Architectural Invariants (Summary)

_Read the specific DESIGN docs for deep implementation details._

1. **Stateless Compute:** Kotlin Cloud Run containers must be 100% stateless. Use the Firestore "scratchpad" pattern for Re-Act loops.
2. **Event-Driven UI:** Frontend uses REST `POST` to trigger jobs, but relies _only_ on Firebase `onSnapshot` listeners to update the UI.
3. **Queue-Worker Pattern:** Long-running LLM tasks must be pushed to Cloud Tasks and processed by idempotent Kotlin workers.
4. **Decoupled Vision:** Images must be parsed to text/Markdown by the Vision model first; never pass raw images into the main Teaching loop.

## 4. Development Workflow & Tooling

1. **Analyze & Plan:** Briefly outline your intended changes and identify the affected Bazel targets.
2. **Idempotency:** Ensure any Kotlin worker you write can safely crash and be retried by Cloud Tasks without data corruption.
3. **Build Files:** Always update `BUILD.bazel` when modifying dependencies or adding new files.
4. **Testing:** Write or update tests (`Jest` for frontend, `JUnit5` for backend).
5. **Formatting & Linting (CRITICAL):** Do NOT waste output tokens trying to manually adhere to perfect code formatting or linting rules. This repository uses automated tools (`Prettier`, `ESLint`, `Ktlint`). Write logically sound code and explicitly instruct the user to run the respective Bazel format/lint targets to clean up the syntax.
6. **Pre-Commit Check:** `bazel run //:format` MUST be invoked before any commit to ensure repository consistency.
