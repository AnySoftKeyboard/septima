# Security, Authentication, and Authorization

## Core Identity Layer (Firebase Authentication)

The system uses **Firebase Authentication** to manage user identities. This provides a secure, token-based authentication mechanism without requiring the Kotlin backend to manage passwords or session cookies.

- **Implementation:** The TypeScript frontend utilizes the Firebase Web SDK.
- **Multi-Tenancy:** The system uses a strict 1:1 account structure. Each user has their own distinct login, which maps directly to a unique Firebase `uid`.

## Client-to-Database Security (Firestore Rules)

Because the frontend utilizes Firestore Listeners to read data directly from the database, security is enforced at the database level using **Firestore Security Rules**.

javascript
rules_version = '2';
service cloud.firestore {
match /databases/{database}/documents {

    // Lock down the entire database by default
    match /{document=**} {
      allow read, write: if false;
    }

    // Users can only access documents explicitly nested under their unique ID
    match /users/{userId}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Taxonomy and system configs are globally readable but not writable
    match /system/{document=**} {
      allow read: if request.auth != null;
      allow write: if false;
    }

}
}

## Client-to-Server Security (Kotlin REST API)

When the frontend triggers a new session or pushes a task to the backend, it must prove its identity to the stateless Cloud Run container.

- **The Flow:** 1. The frontend retrieves the current JWT (JSON Web Token) from Firebase Auth. 2. It passes this token in the `Authorization: Bearer <token>` header of the POST request. 3. The Kotlin backend uses the Firebase Admin SDK to verify the token signature and extract the `uid`. 4. The backend explicitly checks that the extracted `uid` matches the `userId` in the requested payload before enqueueing any Cloud Tasks.
