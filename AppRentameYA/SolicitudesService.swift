//
//  SolicitudesService.swift
//  AppRentameYA
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
class SolicitudesService: ObservableObject {
    private let db = Firestore.firestore()
    
    @Published var solicitudes: [SolicitudModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Email del administrador
    private let adminEmail = "maydeli.castan@iest.edu.mx"
    
    /// Verifica si el usuario actual es administrador
    func esAdmin() -> Bool {
        return Auth.auth().currentUser?.email == adminEmail
    }
    
    /// Obtiene todas las solicitudes (solo para admin)
    func obtenerTodasLasSolicitudes() async {
        guard esAdmin() else {
            print("⚠️ Solo los administradores pueden ver todas las solicitudes")
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let snapshot = try await db.collection("solicitudes")
                .order(by: "fechaCreacion", descending: true)
                .getDocuments()
            
            solicitudes = snapshot.documents.compactMap { doc in
                try? doc.data(as: SolicitudModel.self)
            }
            
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
            print("❌ Error al obtener solicitudes: \(error.localizedDescription)")
        }
    }
    
    /// Obtiene las solicitudes del usuario actual
    func obtenerMisSolicitudes() async {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let snapshot = try await db.collection("solicitudes")
                .whereField("userId", isEqualTo: userId)
                .order(by: "fechaCreacion", descending: true)
                .getDocuments()
            
            solicitudes = snapshot.documents.compactMap { doc in
                try? doc.data(as: SolicitudModel.self)
            }
            
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
            print("❌ Error al obtener mis solicitudes: \(error.localizedDescription)")
        }
    }
    
    /// Aprobar una solicitud
    func aprobarSolicitud(_ solicitud: SolicitudModel) async throws {
        guard esAdmin() else {
            throw NSError(domain: "SolicitudesService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Solo los administradores pueden aprobar solicitudes"])
        }
        
        guard let solicitudId = solicitud.id else {
            throw NSError(domain: "SolicitudesService", code: 2, userInfo: [NSLocalizedDescriptionKey: "ID de solicitud no válido"])
        }
        
        try await db.collection("solicitudes").document(solicitudId).updateData([
            "estado": SolicitudModel.EstadoSolicitud.aprobada.rawValue,
            "fechaActualizacion": FieldValue.serverTimestamp()
        ])
        
        // Actualizar la lista local
        if let index = solicitudes.firstIndex(where: { $0.id == solicitudId }) {
            solicitudes[index].estado = SolicitudModel.EstadoSolicitud.aprobada.rawValue
        }
    }
    
    /// Rechazar una solicitud
    func rechazarSolicitud(_ solicitud: SolicitudModel) async throws {
        guard esAdmin() else {
            throw NSError(domain: "SolicitudesService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Solo los administradores pueden rechazar solicitudes"])
        }
        
        guard let solicitudId = solicitud.id else {
            throw NSError(domain: "SolicitudesService", code: 2, userInfo: [NSLocalizedDescriptionKey: "ID de solicitud no válido"])
        }
        
        try await db.collection("solicitudes").document(solicitudId).updateData([
            "estado": SolicitudModel.EstadoSolicitud.rechazada.rawValue,
            "fechaActualizacion": FieldValue.serverTimestamp()
        ])
        
        // Actualizar la lista local
        if let index = solicitudes.firstIndex(where: { $0.id == solicitudId }) {
            solicitudes[index].estado = SolicitudModel.EstadoSolicitud.rechazada.rawValue
        }
    }
}

