# Build, CI/CD, and Environments

## Build System

The project uses **Bazel** to manage the polyglot repository containing both the TypeScript frontend and the Kotlin backend. Bazel provides hermetic, reproducible builds and exceptional caching.

- `//frontend/...`: Contains the React/TypeScript targets.
- `//backend/...`: Contains the Kotlin API and worker targets.

## Local Development Loop

The local loop relies on emulators to avoid incurring cloud costs or modifying production data during testing:

- **Firebase Local Emulator Suite:** Runs Firestore and Cloud Storage locally.
- **Backend:** Run via `bazel run //backend:dev_server`.
- **Frontend:** Run via `bazel run //frontend:dev_server`.

## Code Quality

- **Linters/Formatters:** - Frontend: `ESLint` and `Prettier`.
  - Backend: `Ktlint` enforced via Bazel rules.
- **Testing:**
  - Frontend: `Jest` for unit testing UI components and state logic.
  - Backend: `JUnit5` for testing state transitions, Re-Act loop logic, and schema validation.

## CI/CD Pipeline

1. **Pull Requests:** Trigger Bazel test targets and linting checks.
2. **Merge to Main:** - Triggers Google Cloud Build.
   - Builds the optimized production React bundle.
   - Containerizes the Kotlin backend into a Docker image.
   - Deploys the container to Google Cloud Run and updates Firebase Hosting for the frontend.
