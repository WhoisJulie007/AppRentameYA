import SwiftUI

struct RentameYaWelcomeView: View {
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground).ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer(minLength: 80)

                Text("RentameYa")
                    .font(.system(size: 36, weight: .heavy, design: .rounded))
                    .foregroundStyle(.primary)

                Text("Renta un auto y empieza a ganar hoy.")
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                VStack(spacing: 14) {
                    Button(action: {}) {
                        Text("Continuar con Apple")
                            .font(.system(size: 16, weight: .semibold))
                            .frame(maxWidth: .infinity, minHeight: 52)
                    }
                    .foregroundStyle(.white)
                    .background(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                    Button(action: {}) {
                        Text("Continuar con Google")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.primary)
                            .frame(maxWidth: .infinity, minHeight: 52)
                    }
                    .background(.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(Color(UIColor.systemGray4), lineWidth: 1)
                    )
                }
                .padding(.horizontal, 20)

                Spacer()
            }
            .padding(.bottom, 24)
        }
    }
}

#Preview {
    RentameYaWelcomeView()
}
