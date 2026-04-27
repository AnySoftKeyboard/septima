# Backend Review Guidelines

- **Statelessness:** Ensure all Cloud Run handlers are 100% stateless.
- **Idempotency:** Verify that Kotlin workers can safely crash and be retried by Cloud Tasks without side effects.
- **Queue-Worker Pattern:** Long-running tasks must be enqueued via Cloud Tasks, not handled in the request thread.
- **Firestore Patterns:** Use the "scratchpad" pattern for Re-Act loops.
- **Testing:** New logic must have a corresponding `kt_jvm_test` Bazel target.
- **Formatting:** Do not comment on formatting; we use `Ktlint`.
