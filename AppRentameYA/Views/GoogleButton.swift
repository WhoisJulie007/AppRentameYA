import SwiftUI

struct GoogleButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {

                Image("google-logo") // Ahorita te digo cómo agregarlo
                    .resizable()
                    .frame(width: 20, height: 20)

                Text("Continuar con Google")
                    .foregroundColor(.black)
                    .font(.system(size: 17, weight: .semibold))

                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 4, y: 2)
        }
        .padding(.horizontal)
    }
}
