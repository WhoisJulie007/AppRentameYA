//
//  AdminSolicitudesView.swift
//  AppRentameYA
//

import SwiftUI

struct AdminSolicitudesView: View {
    @StateObject private var solicitudesService = SolicitudesService()
    @State private var solicitudSeleccionada: SolicitudModel?
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Solicitudes de Renta")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Button(action: {
                    Task {
                        await solicitudesService.obtenerTodasLasSolicitudes()
                    }
                }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.title3)
                }
            }
            .padding()
            .background(Color.white)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
            
            // Lista de solicitudes
            if solicitudesService.isLoading {
                Spacer()
                ProgressView("Cargando solicitudes...")
                Spacer()
            } else if solicitudesService.solicitudes.isEmpty {
                Spacer()
                VStack(spacing: 16) {
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    Text("No hay solicitudes")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(solicitudesService.solicitudes) { solicitud in
                            SolicitudCardView(solicitud: solicitud, solicitudesService: solicitudesService)
                        }
                    }
                    .padding()
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .onAppear {
            Task {
                await solicitudesService.obtenerTodasLasSolicitudes()
            }
        }
    }
}

struct SolicitudCardView: View {
    let solicitud: SolicitudModel
    @ObservedObject var solicitudesService: SolicitudesService
    @State private var mostrandoImagen = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header con estado
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(solicitud.nombreCompleto)
                        .font(.headline)
                    Text(solicitud.userEmail)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                EstadoBadge(estado: solicitud.estadoEnum)
            }
            
            Divider()
            
            // Información
            VStack(alignment: .leading, spacing: 8) {
                InfoRow(icon: "car.fill", text: solicitud.vehiculoNombre)
                InfoRow(icon: "phone.fill", text: solicitud.telefono)
                
                if let fechaCreacion = solicitud.fechaCreacion?.dateValue() {
                    InfoRow(icon: "calendar", text: formatearFecha(fechaCreacion))
                }
            }
            
            // Botones de acción (solo si está pendiente o en revisión)
            if solicitud.estadoEnum == .pendiente || solicitud.estadoEnum == .enRevision {
                HStack(spacing: 12) {
                    Button(action: {
                        Task {
                            do {
                                try await solicitudesService.rechazarSolicitud(solicitud)
                            } catch {
                                print("Error al rechazar: \(error.localizedDescription)")
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: "xmark.circle")
                            Text("Rechazar")
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.red.opacity(0.1))
                        .foregroundColor(.red)
                        .cornerRadius(8)
                    }
                    
                    Button(action: {
                        Task {
                            do {
                                try await solicitudesService.aprobarSolicitud(solicitud)
                            } catch {
                                print("Error al aprobar: \(error.localizedDescription)")
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: "checkmark.circle")
                            Text("Aprobar")
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.green.opacity(0.1))
                        .foregroundColor(.green)
                        .cornerRadius(8)
                    }
                }
            }
            
            // Botón para ver licencia
            Button(action: {
                mostrandoImagen = true
            }) {
                HStack {
                    Image(systemName: "photo")
                    Text("Ver Licencia")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color.blue.opacity(0.1))
                .foregroundColor(.blue)
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .sheet(isPresented: $mostrandoImagen) {
            if let url = URL(string: solicitud.licenciaURL) {
                SafariView(url: url)
            }
        }
    }
    
    private func formatearFecha(_ fecha: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "es_MX")
        return formatter.string(from: fecha)
    }
}

struct InfoRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 20)
            Text(text)
                .font(.subheadline)
        }
    }
}

struct EstadoBadge: View {
    let estado: SolicitudModel.EstadoSolicitud
    
    var body: some View {
        Text(estado.displayName)
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(colorParaEstado(estado).opacity(0.2))
            .foregroundColor(colorParaEstado(estado))
            .cornerRadius(12)
    }
    
    private func colorParaEstado(_ estado: SolicitudModel.EstadoSolicitud) -> Color {
        switch estado {
        case .pendiente: return .orange
        case .enRevision: return .blue
        case .aprobada: return .green
        case .rechazada: return .red
        }
    }
}

// Vista simple para mostrar la imagen en Safari
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

