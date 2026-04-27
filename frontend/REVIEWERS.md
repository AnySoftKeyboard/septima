# Frontend Review Guidelines

- **Reactive UI:** Ensure the UI relies on Firebase `onSnapshot` listeners for updates, not manual polling or WebSocket state.
- **Lightweight POSTs:** API calls should be fire-and-forget `POST` requests to trigger background jobs.
- **Security:** Verify that JWT tokens are correctly retrieved and passed in `Authorization` headers.
- **File Handling:** Heavy files must be uploaded via Signed URLs to GCS.
- **Testing:** Logic changes require a `js_test` Bazel target.
- **Formatting:** Do not comment on formatting; we use `Prettier` and `ESLint`.
