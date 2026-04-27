package septima

import com.google.firebase.auth.FirebaseAuth

fun interface TokenVerifier {
    fun verify(token: String): String
}

class FirebaseTokenVerifier : TokenVerifier {
    override fun verify(token: String): String =
        FirebaseAuth.getInstance().verifyIdToken(token).uid
}
