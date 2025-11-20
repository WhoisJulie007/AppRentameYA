import SwiftUI

struct PerfilViewVisual: View {
    @EnvironmentObject var auth: AuthViewModel
    
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
                VStack(spacing: 24) {
                    
                    // Información del usuario
                    VStack(spacing: 16) {
                        // Avatar/Icono
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.blue)
                            .padding(.top, 20)
                        
                        // Nombre
                        if let displayName = auth.user?.displayName, !displayName.isEmpty {
                            Text(displayName)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                        } else {
                            Text("Usuario")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                        }
                        
                        // Email
                        if let email = auth.user?.email {
                            Text(email)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    // Botón de cerrar sesión
                    Button(action: {
                        auth.signOut()
                    }) {
                        HStack {
                            Image(systemName: "arrow.right.square")
                            Text("Cerrar Sesión")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
        }
    }
}



struct PerfilViewVisual_Previews: PreviewProvider {
    static var previews: some View {
        PerfilViewVisual()
            .environmentObject(AuthViewModel())
    }
}
