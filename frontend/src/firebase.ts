import { initializeApp } from 'firebase/app';
import { connectAuthEmulator, getAuth } from 'firebase/auth';

function requireEnv(key: string): string {
  const value = import.meta.env[key];
  if (!value)
    throw new Error(
      `Missing required env var: ${key}. Copy frontend/.env.local.example to frontend/.env.local and fill in the values.`,
    );
  return value;
}

const firebaseConfig = {
  apiKey: requireEnv('VITE_FIREBASE_API_KEY'),
  authDomain: requireEnv('VITE_FIREBASE_AUTH_DOMAIN'),
  projectId: requireEnv('VITE_FIREBASE_PROJECT_ID'),
};

export const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);

if (import.meta.env.DEV) {
  connectAuthEmulator(auth, 'http://localhost:9099', { disableWarnings: true });
}
