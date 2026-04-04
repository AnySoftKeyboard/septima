import eslint from '@eslint/js';
import tseslint from 'typescript-eslint';

export default tseslint.config(
  {
    files: ['**/*.ts', '**/*.js', '**/*.mjs', '**/*.cjs'],
    extends: [eslint.configs.recommended, ...tseslint.configs.recommended],
    rules: {
      'no-unused-vars': 'warn',
    },
  },
  {
    ignores: ['**/node_modules/**', '**/bazel-*/**', '**/dist/**'],
  },
);
