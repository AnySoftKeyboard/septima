package septima

import io.ktor.http.HttpHeaders
import io.ktor.http.HttpStatusCode
import io.ktor.server.application.ApplicationPlugin
import io.ktor.server.application.createApplicationPlugin
import io.ktor.server.response.respond
import io.ktor.util.AttributeKey

val UidKey: AttributeKey<String> = AttributeKey("uid")

class FirebaseAuthConfig {
    lateinit var verifier: TokenVerifier
}

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
            } catch (_: Exception) {
                call.respond(HttpStatusCode.Unauthorized)
            }
        }
    }
