import SwiftUI
import GoogleSignInSwift

struct RentameYaWelcomeView: View {
    
    @StateObject var auth = AuthViewModel()
    
    var body: some View {
        VStack(spacing: 32) {
            
            Spacer()
            
            // LOGO
            VStack(spacing: 12) {
                Image(systemName: "car")
                    .font(.system(size: 70, weight: .light))
                    .foregroundColor(Color.blue)
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
            
            
            // BOTÓN: GOOGLE (botón oficial)
            GoogleSignInButton {
                Task {
                    await auth.signInWithGoogle()
                }
            }
            .frame(height: 55)
            .padding(.horizontal)

            Spacer()
            
        }
        .padding()
        .background(Color(.systemBackground))
        .ignoresSafeArea()
    }
}

#Preview {
    RentameYaWelcomeView()
}
