import SwiftUI

struct RentameYaInicioView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                // Tarjeta de bienvenida
                CardView {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("¡Hola, Conductor!")
                            .font(.system(.title3, design: .rounded).bold())
                        Text("Bienvenido a tu centro de control. Aquí podrás ver el estado de tu vehículo y encontrar tu próximo auto para seguir ganando.")
                            .font(.system(size: 16))
                            .foregroundStyle(.secondary)
                    }
                }
                
                // Tarjeta azul
                CardView(
                    background: Color.blue.opacity(0.08),
                    borderColor: .blue
                ) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("¿Listo para empezar?")
                            .font(.headline)
                            .foregroundColor(.blue)
                        Text("Navega a la sección de \"Vehículos\" para ver los autos que tenemos disponibles para ti.")
                            .font(.system(size: 16))
                            .foregroundColor(.blue)
                    }
                }
                
                // Beneficios
                CardView {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Nuestros Beneficios")
                            .font(.system(.title3, design: .rounded).bold())
                        
                        BenefitRow(text: "Seguro de cobertura amplia incluido.")
                        BenefitRow(text: "Mantenimientos preventivos cubiertos.")
                        BenefitRow(text: "Autos listos para plataformas (Uber/DiDi).")
                    }
                }
                
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationBarTitle("Inicio")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        RentameYaInicioView()
    }
}
