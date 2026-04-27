# Septima: A General-Purpose AI Tutor

## Product Overview

Septima is a lightweight, highly adaptable AI tutoring web application designed to act as a personalized educator for children. Rather than a static Q&A bot, this system dynamically adjusts its pedagogical approach based on inferred user comprehension, historical learning data, and cross-subject semantic memory.

The AI tutor interface is presented to the student under the persona of **Ms. Clark**.

## Septima Clark

This service is named after [Septima Poinsette Clark](https://en.wikipedia.org/wiki/Septima_Poinsette_Clark), a pioneering American educator and civil rights activist often referred to as the "Queen mother" of the Civil Rights Movement. Her lifelong dedication to adult education, literacy, and community empowerment was built on a deep respect for her students. She believed that true teaching required treating the student as an equal partner in the learning process—a philosophy that serves as the core directive for this AI.

## Primary Goals

- Provide a structured, patient teaching experience that guides students to answers rather than just providing them.
- Maintain a persistent, evolving memory of a student's strengths and weaknesses across different subjects.
- Offer a seamless, real-time user interface capable of handling text, document uploads, and direct camera captures.

## Key Features

- **Session-Based Learning:** Dedicated workspaces for individual subjects or homework assignments.
- **Adaptive Pedagogy:** Ms. Clark evaluates the user's level and adjusts vocabulary and teaching methods accordingly.
- **Multimodal Inputs:** Support for uploading PDFs, text files, and images (e.g., math worksheets or handwritten notes).
- **Semantic Memory:** Tracks micro-skills over time using vector embeddings, allowing the tutor to reference past successes in unrelated subjects to explain new concepts.
- **Parental Insights:** Generates structured report cards detailing progress, mastery levels, and areas needing improvement.

## High-Level Technical Stack

- **Frontend:** TypeScript / React
- **Backend:** Kotlin (Idempotent Queue-Worker architecture)
- **Infrastructure:** Google Cloud Platform (Cloud Run, Cloud Tasks, Cloud Storage)
- **Database/State:** Google Cloud Firestore (Hybrid Document & Vector Store)
- **AI Models:** Google Gemini 3.1 ecosystem (Pro, Flash, and Flash-Lite)

## Local Development

Septima is a Bazel-managed polyglot monorepo. **Bazel is the single entry point for all application tooling** — do not run `pnpm dev`, `npm run …`, or `gradle run` directly. Build, test, format, and dev-server targets all live behind `bazel run` / `bazel test`.

### Prerequisites

- **Bazel** — pinned by `.bazelversion`. Use [`bazelisk`](https://github.com/bazelbuild/bazelisk) so the right version is fetched automatically.
- **JDK 21+** — Bazel uses an embedded JDK for the build itself, but a host JDK is needed for IDE integration (IntelliJ / Kotlin LSP).
- **Node.js 24+** — Bazel ships its own Node toolchain (`MODULE.bazel`), so a host install is needed only for editor TypeScript support.
- **pnpm 10+** — used **only** to regenerate `pnpm-lock.yaml`. Never used to install or run app code.
- **Firebase CLI** (`npm i -g firebase-tools`) — runs the local Auth emulator. Required to run the backend dev server.
- **Google Cloud SDK** (`gcloud`) — needed once to authenticate for Application Default Credentials (`gcloud auth application-default login`). Also required for production deploys.

### First-time setup

```sh
git clone <repo>
cd septima
gcloud auth application-default login   # one-time: provides ADC for the backend
bazel build //...                        # warms caches, fetches toolchains
bazel test //...                         # confirms the suite is green
```

### Everyday commands

| Goal                    | Command                         |
| ----------------------- | ------------------------------- |
| Run the full test suite | `bazel test //...`              |
| Run backend tests only  | `bazel test //backend/...`      |
| Run frontend tests only | `bazel test //frontend/...`     |
| Format the entire repo  | `bazel run //:format`           |
| Build a specific target | `bazel build //backend:backend` |

### Dev servers and emulators

The dev loop runs entirely against the Firebase Emulator Suite to avoid touching production data or incurring cloud costs (see `docs/DESIGN-BUILD.md`).

```sh
# Terminal 1 — Firebase Auth emulator (UI at http://localhost:4000)
firebase emulators:start

# Terminal 2 — Kotlin backend (Ktor on :8080)
GOOGLE_CLOUD_PROJECT=septima-dev \
FIREBASE_AUTH_EMULATOR_HOST=localhost:9099 \
bazel run //backend:dev_server

# Terminal 3 — Vite-powered React frontend (not yet implemented)
bazel run //frontend:dev_server
```

> `//frontend:dev_server` is not yet implemented. Until it lands, only the backend and test targets above are available.

### Updating dependencies

Whenever you change a manifest, regenerate the matching lockfile and commit both files together.

- **Maven (Kotlin):** edit `MODULE.bazel`, then `REPIN=1 bazel run @maven//:pin`.
- **npm (TypeScript):** edit `package.json`, then `pnpm install --lockfile-only`.

### Environment configuration

Local dev points the Firebase Web SDK at the emulator host (defaults to `127.0.0.1:8080` for Firestore, `127.0.0.1:9199` for Storage). The frontend reads these from `import.meta.env.VITE_*` variables baked in at build time — see `frontend/.env.local.example` once it is added. No production secrets are ever required for local development.

### Pre-commit checklist

CI mirrors these two commands; run them before every commit to keep the tree green:

```sh
bazel run //:format
bazel test //...
```
