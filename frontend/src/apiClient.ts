export function createApiClient(
  getToken: () => Promise<string>,
  baseUrl: string,
  fetcher: typeof fetch = fetch,
) {
  return {
    async post<T>(path: string, body?: unknown): Promise<T> {
      const token = await getToken();
      const response = await fetcher(`${baseUrl}${path}`, {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${token}`,
          'Content-Type': 'application/json',
        },
        body: body != null ? JSON.stringify(body) : undefined,
      });
      if (!response.ok) throw new Error(`HTTP ${response.status}`);
      return response.json() as Promise<T>;
    },
  };
}
