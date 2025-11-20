import SwiftUI

struct RentameYaMainView: View {
    
    @EnvironmentObject var auth: AuthViewModel
    @State private var selectedTab: RentameYaTab = .inicio
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                // CONTENIDO PRINCIPAL SEGÚN TAB
                Group {
                    switch selectedTab {
                    case .inicio:
                        RentameYaInicioView()
                    case .vehiculos:
                        VehiculosView()
                    case .perfil:
                        PerfilViewVisual()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // TAB BAR
                Divider()
                HStack {
                    Spacer()
                    TabItem(icon: "house.fill", title: "Inicio", isSelected: selectedTab == .inicio) {
                        selectedTab = .inicio
                    }
                    Spacer()
                    TabItem(icon: "car.fill", title: "Vehículos", isSelected: selectedTab == .vehiculos) {
                        selectedTab = .vehiculos
                    }
                    Spacer()
                    TabItem(icon: "person.fill", title: "Perfil", isSelected: selectedTab == .perfil) {
                        selectedTab = .perfil
                    }
                    Spacer()
                }
                .padding(.vertical, 8)
                .background(.white)
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    RentameYaMainView()
        .environmentObject(AuthViewModel())
}
