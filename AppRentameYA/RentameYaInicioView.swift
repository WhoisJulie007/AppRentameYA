import SwiftUI

struct RentameYaInicioView: View {
    var body: some View {
        VStack(spacing: 0) {
            // ===== CONTENIDO PRINCIPAL =====
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Tarjeta de bienvenida
                    CardView {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("¡Hola, Conductor!")
                                .font(.system(.title3, design: .rounded).weight(.bold))
                            Text("Bienvenido a tu centro de control. Aquí podrás ver el estado de tu vehículo y encontrar tu próximo auto para seguir ganando.")
                                .font(.system(size: 16))
                                .foregroundStyle(.secondary)
                        }
                    }

                    // Tarjeta azul de acción
                    CardView(
                        background: Color.blue.opacity(0.08),
                        borderColor: Color.blue
                    ) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("¿Listo para empezar?")
                                .font(.system(.headline, design: .rounded).weight(.semibold))
                                .foregroundColor(.blue)
                            Text("Navega a la sección de \"Vehículos\" para ver los autos que tenemos disponibles para ti.")
                                .font(.system(size: 16))
                                .foregroundColor(.blue)
                        }
                    }

                    // Tarjeta de beneficios
                    CardView {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Nuestros Beneficios")
                                .font(.system(.title3, design: .rounded).weight(.bold))

                            BenefitRow(text: "Seguro de cobertura amplia incluido.")
                            BenefitRow(text: "Mantenimientos preventivos cubiertos.")
                            BenefitRow(text: "Autos listos para plataformas (Uber/DiDi).")
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
                .padding(.bottom, 12)
            }

            // ===== BARRA INFERIOR PERSONALIZADA =====
            VStack(spacing: 4) {
                Divider()
                HStack {
                    Spacer()
                    TabBarItemVisual(title: "Inicio", imageName: "house.fill", isSelected: true)
                    Spacer()
                    TabBarItemVisual(title: "Vehículos", imageName: "car.fill", isSelected: false)
                    Spacer()
                    TabBarItemVisual(title: "Perfil", imageName: "person.fill", isSelected: false)
                    Spacer()
                }
                .padding(.vertical, 8)
                .background(Color.white)
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle("Inicio")
        .navigationBarTitleDisplayMode(.large)
    }
}







#Preview {
    NavigationStack {
        RentameYaInicioView()
    }
}
