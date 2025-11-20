import SwiftUI

struct RentameYaWelcomeView: View {

    @StateObject var auth = AuthViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {

                Spacer()

                // LOGO Y TÍTULO
                VStack(spacing: 12) {
                    Image(systemName: "house")
                        .font(.system(size: 70, weight: .light))
                        .foregroundColor(.blue)
                        .padding(.bottom, 8)

                    Text("RentameYa")
                        .font(.system(size: 36, weight: .bold))

                    Text("Renta un auto y empieza a ganar hoy.")
                        .font(.system(size: 18))
                        .foregroundColor(.gray)
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)

                Spacer()

                // GOOGLE BUTTON (custom bonito)
                GoogleButton {
                    Task { await auth.signInWithGoogle() }
                }

                Spacer()

            }
            .padding()
            .background(Color(.systemBackground))
            .ignoresSafeArea()
            .navigationDestination(isPresented: $auth.isAuthenticated) {
                RentameYaInicioView()   // ← Aquí navega automáticamente
            }
        }
    }
}

#Preview {
    RentameYaWelcomeView()
}
