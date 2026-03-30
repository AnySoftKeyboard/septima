# Backend Services and Data Architecture

## Tech Stack
- **Language:** Kotlin
- **Compute:** Google Cloud Run (Serverless, scales to zero)
- **Orchestration:** Google Cloud Tasks (Queue-Worker model)
- **Database:** Google Cloud Firestore
- **Storage:** Google Cloud Storage (GCS)

## Architecture: Queue-Worker Model
To ensure stateless, fault-tolerant execution that survives container restarts, the backend operates entirely on asynchronous tasks.
- **Endpoints:**
  - `POST /session/start`: Initializes Firestore schemas and enqueues the first task.
  - `POST /worker/inference`: Pulled by Cloud Tasks. Executes Gemini LLM calls and determines the next step.
  - `POST /worker/execute-tool`: Pulled by Cloud Tasks. Executes web searches, vector queries, or image parsing.

## Database Schemas (Firestore)
**1. `Session` Document** (`/users/{uid}/sessions/{sessionId}`)
- Metadata: `topic`, `status`, `startTime`.
- **`react_state` (Sub-document):** The externalized scratchpad. Tracks `loopCount`, `accumulatedContext`, and `pendingToolCall` to allow mid-flight crash recovery.

**2. `Message` Document** (`/users/{uid}/sessions/{sessionId}/messages/{messageId}`)
- Stores `role`, `content`, `timestamp`.
- Includes `attachments`: Array containing the GCS URL *and* the extracted text representation from the vision model.

**3. `KnowledgeNode` Document** (`/users/{uid}/knowledge/{nodeId}`)
- A hybrid schema for semantic memory and reporting.
- Contains the `fact` string, the floating-point `embedding` array, and standard metadata (`broadDomain`, `masteryLevel`, `timestamp`).
