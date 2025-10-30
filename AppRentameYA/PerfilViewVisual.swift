import SwiftUI

struct PerfilViewVisual: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Mi Perfil")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding()
            .background(Color.white)
            .foregroundColor(Color.black)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
            
            ZStack {
                Color(.white)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    
                    VStack(alignment: .center) {
                        Text("Página en Construcción")
                            .font(.headline)
                            .padding(.bottom, 5)
                        
                        Text("Próximamente aquí podrás ver los detalles de tu cuenta y el historial de tus rentas.")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)
                    .padding(.top, 20)
                    Spacer()
                }
            }
            
            
            VStack(spacing: 4) {
                Divider()
                HStack {
                    Spacer()
                    TabBarItemVisual(title: "Inicio", imageName: "house.fill", isSelected: false)
                    Spacer()
                    TabBarItemVisual(title: "Vehículos", imageName: "car.fill", isSelected: false)
                    Spacer()
                    TabBarItemVisual(title: "Perfil", imageName: "person.fill", isSelected: true) // Perfil seleccionado
                    Spacer()
                }
                .padding(.vertical, 8)
                .background(Color.white)
            }
        }
    }
}



struct PerfilViewVisual_Previews: PreviewProvider {
    static var previews: some View {
        PerfilViewVisual()
    }
}
