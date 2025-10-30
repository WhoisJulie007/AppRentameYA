import SwiftUI

struct SolicitudEnviadaViewVisual: View {
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Color.white
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    
                    ZStack {
                        Circle()
                            .stroke(Color.green, lineWidth: 5)
                            .frame(width: 100, height: 100)
                            .opacity(0.3) // Anillo exterior tenue
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 50, weight: .bold))
                            .foregroundColor(.green)
                            .padding(20)
                            .background(Color.green.opacity(0.15))
                            .clipShape(Circle())
                    }
                    .padding(.bottom, 40)
                    
                    Text("¡Solicitud Enviada!")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                    
                    Text("Hemos recibido tus datos. Pronto nos pondremos en contacto contigo para los siguientes pasos.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 60)
                    
                    
                    Text("Volver al Inicio")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                        .padding(.horizontal, 40)
                    
                    Spacer()
                    Spacer()
                }
            }
            
            
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
    }
}




struct SolicitudEnviadaViewVisual_Previews: PreviewProvider {
    static var previews: some View {
        SolicitudEnviadaViewVisual()
    }
}
