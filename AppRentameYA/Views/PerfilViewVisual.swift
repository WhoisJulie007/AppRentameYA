import SwiftUI
import Combine

struct PerfilViewVisual: View {
    @EnvironmentObject var auth: AuthViewModel
    @StateObject private var solicitudesService = SolicitudesService()
    @StateObject private var firestoreManager = FirestoreManager()
    @State private var mostrarAdmin = false
    @State private var mostrarAgregarVehiculo = false
    
    private var esAdmin: Bool {
        solicitudesService.esAdmin()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(LocalizedKey.myProfile.localized)
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding()
            .background(Color.white)
            .foregroundColor(Color.black)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
            
            ScrollView {
                VStack(spacing: 20) {
                    // Información del usuario
                    VStack(spacing: 16) {
                        // Avatar/Icono
                        Image(systemName: esAdmin ? "person.crop.circle.badge.checkmark" : "person.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(esAdmin ? .green : .blue)
                            .padding(.top, 20)
                        
                        // Nombre
                        if let displayName = auth.user?.displayName, !displayName.isEmpty {
                            Text(displayName)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                        } else {
                            Text(LocalizedKey.user.localized)
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
                        
                        // Badge de admin
                        if esAdmin {
                            HStack {
                                Image(systemName: "shield.checkmark")
                                Text(LocalizedKey.administrator.localized)
                            }
                            .font(.caption)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.green.opacity(0.2))
                            .foregroundColor(.green)
                            .cornerRadius(12)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    // Botones de Admin (solo si es admin)
                    if esAdmin {
                        VStack(spacing: 12) {
                            Button(action: {
                                mostrarAdmin = true
                            }) {
                                HStack {
                                    Image(systemName: "list.bullet.clipboard")
                                    Text(LocalizedKey.reviewApplications.localized)
                                        .fontWeight(.semibold)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                            
                            Button(action: {
                                mostrarAgregarVehiculo = true
                            }) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text(LocalizedKey.addVehicle.localized)
                                        .fontWeight(.semibold)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Botón de cerrar sesión
                    Button(action: {
                        auth.signOut()
                    }) {
                        HStack {
                            Image(systemName: "arrow.right.square")
                            Text(LocalizedKey.signOut.localized)
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            .background(Color(.systemGroupedBackground))
        }
        .sheet(isPresented: $mostrarAdmin) {
            NavigationStack {
                AdminSolicitudesView()
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(LocalizedKey.close.localized) {
                                mostrarAdmin = false
                            }
                        }
                    }
            }
        }
        .sheet(isPresented: $mostrarAgregarVehiculo) {
            AgregarVehiculoView(firestoreManager: firestoreManager)
        }
    }
}

struct SolicitudUsuarioCard: View {
    let solicitud: SolicitudModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(solicitud.vehiculoNombre)
                        .font(.headline)
                    if let fechaCreacion = solicitud.fechaCreacion?.dateValue() {
                        Text(formatearFecha(fechaCreacion))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                Spacer()
                EstadoBadge(estado: solicitud.estadoEnum)
            }
            
            Divider()
            
            HStack {
                Image(systemName: "person.fill")
                    .foregroundColor(.gray)
                Text(solicitud.nombreCompleto)
                    .font(.subheadline)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private func formatearFecha(_ fecha: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "es_MX")
        return formatter.string(from: fecha)
    }
}



struct PerfilViewVisual_Previews: PreviewProvider {
    static var previews: some View {
        PerfilViewVisual()
            .environmentObject(AuthViewModel())
    }
}
