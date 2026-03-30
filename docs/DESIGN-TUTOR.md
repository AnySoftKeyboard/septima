# AI Flows, Pedagogy, and State Transitions

## Model Tiering Strategy
- **Context Gatherer:** Gemini 3.1 Flash (Fast, optimized for tool/MCP usage).
- **Vision Parser:** Gemini 3.1 Flash-Lite (Fast, cost-efficient image-to-text extraction).
- **Teaching State:** Gemini 3.1 Pro (Heavyweight reasoning, massive context, high pedagogical empathy).
- **Post-Session Reflection:** Gemini 3.1 Flash-Lite (Summarization) + Gemini Text Embedding API.

## Phase 1: Context Gathering (Re-Act Loop)
**Goal:** Build a comprehensive `CollectorState` before teaching begins.
1. The Kotlin worker feeds the initial wizard inputs to Gemini 3.1 Flash.
2. The model uses tools (Web Search, Memory Retrieval) to fulfill the schema constraints (Subject, Core Concept, Inferred User Level).
3. **Loop Constraint:** Maximum 20 iterations.
4. **Clarification:** If the model cannot fulfill the schema, it pauses the loop and prompts the user for clarification.
5. **Transition:** Once the schema is filled, it flips `isReadyToTeach` to true.

## Phase 2: The Teaching State
**Goal:** Guide the student using a structured pedagogical framework under the persona of Ms. Clark.
- The session switches to Gemini 3.1 Pro, loaded with the completed `CollectorState`, retrieved `KnowledgeNodes`, and the system instructions to act as Ms. Clark.
- **Pedagogical Loop:**
  1. **Summarize:** Ms. Clark outlines what is about to be learned.
  2. **Demonstrate:** Provide examples tailored to the inferred user level.
  3. **Assess:** Check for understanding before moving on.
  4. **Adapt:** If the user struggles, provide more examples or pivot to a completely different teaching methodology. If a method resonates, Ms. Clark drops an internal note in the chat context.

## Phase 3: Post-Session Reflection
**Goal:** Update the user's long-term semantic memory.
- When the session ends, a hidden asynchronous job reads the chat transcript.
- Gemini 3.1 Flash-Lite extracts new mastered concepts and ongoing struggles.
- The text facts are converted to vector embeddings and stored as `KnowledgeNodes` in Firestore for future similarity searches.
