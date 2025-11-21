import SwiftUI

struct RentameYaWelcomeView: View {

    @EnvironmentObject var auth: AuthViewModel

    var body: some View {
        VStack(spacing: 32) {

            Spacer()

            // LOGO Y TÍTULO
            VStack(spacing: 12) {
                Image(systemName: "car")
                    .font(.system(size: 70, weight: .light))
                    .foregroundColor(.blue)
                    .padding(.bottom, 8)

                    Text(LocalizedKey.appName.localized)
                        .font(.system(size: 36, weight: .bold))

                    Text(LocalizedKey.welcomeSubtitle.localized)
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
    }
}

#Preview {
    RentameYaWelcomeView()
        .environmentObject(AuthViewModel())
}
