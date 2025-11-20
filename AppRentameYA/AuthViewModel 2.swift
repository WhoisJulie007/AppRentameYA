import Foundation
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

@MainActor
class AuthViewModel: ObservableObject {
    @Published var user: User?

    init() {
        self.user = Auth.auth().currentUser
    }

    // ----------------------------------------------------------
    // MARK: - GOOGLE SIGN IN
    // ----------------------------------------------------------
    func signInWithGoogle() async {
        guard let vc = UIApplication.shared.topViewController() else {
            print("No top view controller found")
            return
        }

        do {
            // 1. Abrir Google Sign-In
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: vc)

            // 2. Obtener token
            guard let idToken = result.user.idToken?.tokenString else {
                print("No id token found")
                return
            }

            // 3. Crear credencial de Firebase
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: result.user.accessToken.tokenString
            )

            // 4. Iniciar sesión en Firebase
            let authResult = try await Auth.auth().signIn(with: credential)

            // 5. Guardar usuario
            self.user = authResult.user
            print("Login exitoso con Google:", authResult.user.email ?? "Sin correo")

        } catch {
            print("Google Sign-In error:", error.localizedDescription)
        }
    }

    // ----------------------------------------------------------
    // MARK: - LOGOUT
    // ----------------------------------------------------------
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
            print("Sesión cerrada")
        } catch {
            print("Error al cerrar sesión:", error.localizedDescription)
        }
    }
}
