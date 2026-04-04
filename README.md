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
