import SwiftUI
import Combine

struct RentameYaInicioView: View {
    @StateObject private var solicitudesService = SolicitudesService()
    
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
                
                // Mis Solicitudes
                CardView {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Mis Solicitudes")
                                .font(.system(.title3, design: .rounded).bold())
                            Spacer()
                            if solicitudesService.isLoading {
                                ProgressView()
                                    .scaleEffect(0.8)
                            }
                        }
                        
                        if solicitudesService.solicitudes.isEmpty && !solicitudesService.isLoading {
                            VStack(spacing: 8) {
                                Image(systemName: "doc.text")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                                Text("No tienes solicitudes")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                        } else {
                            VStack(spacing: 12) {
                                ForEach(solicitudesService.solicitudes) { solicitud in
                                    SolicitudUsuarioCard(solicitud: solicitud)
                                }
                            }
                        }
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
        .onAppear {
            // Iniciar listener para actualizaciones en tiempo real
            solicitudesService.iniciarListenerMisSolicitudes()
            
            // También cargar una vez al aparecer
            Task {
                await solicitudesService.obtenerMisSolicitudes()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("NuevaSolicitudEnviada"))) { _ in
            // Refrescar cuando se envía una nueva solicitud
            Task {
                await solicitudesService.obtenerMisSolicitudes()
            }
        }
    }
}

#Preview {
    NavigationStack {
        RentameYaInicioView()
    }
}
