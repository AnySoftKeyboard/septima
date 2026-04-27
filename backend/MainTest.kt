package septima

import io.ktor.client.request.header
import io.ktor.client.request.post
import io.ktor.client.statement.bodyAsText
import io.ktor.http.HttpHeaders
import io.ktor.http.HttpStatusCode
import io.ktor.server.testing.testApplication
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test

class MainTest {
  private val fakeVerifier = TokenVerifier { token ->
    if (token == "valid-token") "user-123"
    else throw IllegalArgumentException("invalid token: $token")
  }

  @Test
  fun `missing auth header returns 401`() = testApplication {
    application { configureServer(fakeVerifier) }
    val response = client.post("/ping")
    assertEquals(HttpStatusCode.Unauthorized, response.status)
  }

  @Test
  fun `invalid token returns 401`() = testApplication {
    application { configureServer(fakeVerifier) }
    val response = client.post("/ping") { header(HttpHeaders.Authorization, "Bearer bad-token") }
    assertEquals(HttpStatusCode.Unauthorized, response.status)
  }

  @Test
  fun `valid token returns uid`() = testApplication {
    application { configureServer(fakeVerifier) }
    val response = client.post("/ping") { header(HttpHeaders.Authorization, "Bearer valid-token") }
    assertEquals(HttpStatusCode.OK, response.status)
    assertEquals("user-123", response.bodyAsText())
  }
}
