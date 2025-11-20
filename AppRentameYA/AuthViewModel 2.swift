import Foundation
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

@MainActor
class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var isAuthenticated = false

    init() {
        self.user = Auth.auth().currentUser
        self.isAuthenticated = (self.user != nil)
    }

    func signInWithGoogle() async {
        guard let vc = UIApplication.shared.topViewController() else { return }

        do {
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: vc)

            guard let idToken = result.user.idToken?.tokenString else { return }

            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: result.user.accessToken.tokenString
            )

            let authResult = try await Auth.auth().signIn(with: credential)

            self.user = authResult.user
            self.isAuthenticated = true

            print("🔥 Login exitoso con Google:", authResult.user.email ?? "")

        } catch {
            print("❌ Error Google Sign-In:", error.localizedDescription)
        }
    }

    func signOut() {
        try? Auth.auth().signOut()
        user = nil
        isAuthenticated = false
    }
}
