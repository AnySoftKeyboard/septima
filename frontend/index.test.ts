import assert from 'node:assert';
import test from 'node:test';
import { createApiClient } from './src/apiClient.js';

test('attaches Authorization Bearer header', async () => {
  let capturedInit: RequestInit | undefined;
  const mockFetch = async (
    _url: string | URL | Request,
    init?: RequestInit,
  ): Promise<Response> => {
    capturedInit = init;
    return new Response(JSON.stringify({}), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  };

  const client = createApiClient(
    async () => 'test-token',
    'http://localhost:8080',
    mockFetch as typeof fetch,
  );
  await client.post('/ping');

  const headers = capturedInit?.headers as Record<string, string>;
  assert.strictEqual(headers['Authorization'], 'Bearer test-token');
});

test('sends POST to the correct URL', async () => {
  let capturedUrl: string | URL | Request = '';
  const mockFetch = async (
    url: string | URL | Request,
    _init?: RequestInit,
  ): Promise<Response> => {
    capturedUrl = url;
    return new Response(JSON.stringify({}), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  };

  const client = createApiClient(
    async () => 'token',
    'http://localhost:8080',
    mockFetch as typeof fetch,
  );
  await client.post('/ping');
  assert.strictEqual(capturedUrl, 'http://localhost:8080/ping');
});

test('throws on non-ok response', async () => {
  const mockFetch = async (): Promise<Response> =>
    new Response('', { status: 401 });
  const client = createApiClient(
    async () => 'token',
    'http://localhost:8080',
    mockFetch as typeof fetch,
  );
  await assert.rejects(
    () => client.post('/ping'),
    (err: Error) => {
      assert.match(err.message, /HTTP 401/);
      return true;
    },
  );
});
