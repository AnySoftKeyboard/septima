export function createApiClient(
  getToken: () => Promise<string>,
  baseUrl: string,
  fetcher: typeof fetch = fetch,
) {
  return {
    async post<T>(path: string, body?: unknown): Promise<T> {
      const token = await getToken();
      const response = await fetcher(new URL(path, baseUrl).toString(), {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${token}`,
          'Content-Type': 'application/json',
        },
        body: body != null ? JSON.stringify(body) : undefined,
      });
      if (!response.ok) {
        const detail = await response.text().catch(() => '');
        throw new Error(
          `HTTP ${response.status}${detail ? `: ${detail}` : ''}`,
        );
      }
      if (
        response.status === 204 ||
        response.headers.get('content-length') === '0'
      ) {
        return undefined as T;
      }
      return response.json() as Promise<T>;
    },
  };
}
