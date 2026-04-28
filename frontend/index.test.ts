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

test('throws on non-ok response with status code', async () => {
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

test('includes server error body in thrown error', async () => {
  const mockFetch = async (): Promise<Response> =>
    new Response('Unauthorized: token expired', { status: 401 });
  const client = createApiClient(
    async () => 'token',
    'http://localhost:8080',
    mockFetch as typeof fetch,
  );
  await assert.rejects(
    () => client.post('/ping'),
    (err: Error) => {
      assert.match(err.message, /token expired/);
      return true;
    },
  );
});

test('returns undefined for 204 No Content', async () => {
  const mockFetch = async (): Promise<Response> =>
    new Response(null, { status: 204 });
  const client = createApiClient(
    async () => 'token',
    'http://localhost:8080',
    mockFetch as typeof fetch,
  );
  const result = await client.post('/trigger');
  assert.strictEqual(result, undefined);
});
