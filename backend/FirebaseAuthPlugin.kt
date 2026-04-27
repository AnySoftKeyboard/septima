package septima

import io.ktor.http.HttpHeaders
import io.ktor.http.HttpStatusCode
import io.ktor.server.application.ApplicationPlugin
import io.ktor.server.application.createApplicationPlugin
import io.ktor.server.response.respond
import io.ktor.util.AttributeKey
import org.slf4j.LoggerFactory

val UidKey: AttributeKey<String> = AttributeKey("uid")

class FirebaseAuthConfig {
    lateinit var verifier: TokenVerifier
}

private val logger = LoggerFactory.getLogger("septima.FirebaseAuthPlugin")

val FirebaseAuthPlugin: ApplicationPlugin<FirebaseAuthConfig> =
    createApplicationPlugin("FirebaseAuth", ::FirebaseAuthConfig) {
        onCall { call ->
            val token =
                call.request.headers[HttpHeaders.Authorization]
                    ?.takeIf { it.startsWith("Bearer ") }
                    ?.removePrefix("Bearer ")
                    ?.trim()
                    ?.takeIf { it.isNotBlank() }

            if (token == null) {
                call.respond(HttpStatusCode.Unauthorized)
                return@onCall
            }

            try {
                val uid = pluginConfig.verifier.verify(token)
                call.attributes.put(UidKey, uid)
            } catch (e: Exception) {
                logger.warn("Token verification failed: ${e.message}")
                call.respond(HttpStatusCode.Unauthorized)
            }
        }
    }
