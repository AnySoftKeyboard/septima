package septima

import com.google.auth.oauth2.GoogleCredentials
import com.google.firebase.FirebaseApp
import com.google.firebase.FirebaseOptions
import io.ktor.server.application.Application
import io.ktor.server.application.install
import io.ktor.server.engine.embeddedServer
import io.ktor.server.netty.Netty
import io.ktor.server.response.respondText
import io.ktor.server.routing.post
import io.ktor.server.routing.routing

fun main() {
    val projectId =
        requireNotNull(System.getenv("GOOGLE_CLOUD_PROJECT")) {
            "GOOGLE_CLOUD_PROJECT env var is required"
        }
    if (FirebaseApp.getApps().isEmpty()) {
        FirebaseApp.initializeApp(
            FirebaseOptions.builder()
                .setCredentials(GoogleCredentials.getApplicationDefault())
                .setProjectId(projectId)
                .build(),
        )
    }
    val port = System.getenv("PORT")?.toInt() ?: 8080
    embeddedServer(Netty, port = port) {
        configureServer(FirebaseTokenVerifier())
    }.start(wait = true)
}

fun Application.configureServer(verifier: TokenVerifier) {
    install(FirebaseAuthPlugin) {
        this.verifier = verifier
    }
    routing {
        post("/ping") {
            call.respondText(call.attributes[UidKey])
        }
    }
}
