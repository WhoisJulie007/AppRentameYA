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
                        Text(LocalizedKey.helloDriver.localized)
                            .font(.system(.title3, design: .rounded).bold())
                        Text(LocalizedKey.welcomeMessage.localized)
                            .font(.system(size: 16))
                            .foregroundStyle(.secondary)
                    }
                }
                
                // Mis Solicitudes
                CardView {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(LocalizedKey.myApplications.localized)
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
                                Text(LocalizedKey.noApplications.localized)
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
                        Text(LocalizedKey.readyToStart.localized)
                            .font(.headline)
                            .foregroundColor(.blue)
                        Text(LocalizedKey.readyToStartMessage.localized)
                            .font(.system(size: 16))
                            .foregroundColor(.blue)
                    }
                }
                
                // Beneficios
                CardView {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(LocalizedKey.ourBenefits.localized)
                            .font(.system(.title3, design: .rounded).bold())
                        
                        BenefitRow(text: LocalizedKey.benefit1.localized)
                        BenefitRow(text: LocalizedKey.benefit2.localized)
                        BenefitRow(text: LocalizedKey.benefit3.localized)
                    }
                }
                
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationBarTitle(LocalizedKey.inicio.localized)
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
