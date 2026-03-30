# Frontend UI/UX and Interactions

## Tech Stack
- **Language:** TypeScript
- **Framework:** React (Next.js or Vite)
- **State/Real-time:** Firebase Web SDK (`onSnapshot` listeners)

## User Interface Layout
- **Left Sidebar:** A chronological list of current and previous tutoring sessions, filterable by subject or date.
- **Main Content Area:** The primary chat interface for the active session with **Ms. Clark**.
- **Input Area:** Text input field with attachment controls (clip icon for files/PDFs, camera icon for direct image capture).

## Core UX Flows
1. **New Session Wizard:**
   - Prompts the user for the lesson subject (e.g., "geometry homework", "Civil War").
   - Provides a dropzone/camera capture for initial materials.
   - Includes a large text area for specific guidance.
2. **The "Thinking" State:**
   - While the backend gathers context, the UI displays transient, real-time updates (e.g., "Searching the web...", "Reading your uploaded image...").
3. **Interactive Tutoring:**
   - Chat bubbles support markdown formatting. Avatars should clearly distinguish the student from Ms. Clark.
   - The user can explicitly type commands to skip steps or ask Ms. Clark for a different teaching method.

## Client-Server Interaction
- **Triggering Actions:** The UI uses lightweight REST `POST` calls (e.g., `/session/start`, `/session/message`) to enqueue background jobs. It does *not* wait for the LLM response on this request.
- **Reactive Updates:** The UI binds to Firestore documents using `onSnapshot`. As the Kotlin backend executes tools and streams LLM tokens, Firestore pushes the deltas to the client, instantly re-rendering the chat without manual polling.
- **File Uploads:** The UI requests a Signed URL from the backend and uploads heavy files directly to Google Cloud Storage to preserve backend bandwidth.
