//
//  SolicitudModel.swift
//  AppRentameYA
//

import Foundation
import FirebaseFirestore

struct SolicitudModel: Identifiable, Codable {
    @DocumentID var id: String?
    var userId: String
    var userEmail: String
    var vehiculoNombre: String
    var nombreCompleto: String
    var telefono: String
    var licenciaURL: String
    var aceptaTerminos: Bool
    var estado: String // Guardado como string para Firestore
    var fechaCreacion: Timestamp?
    var fechaActualizacion: Timestamp?
    
    // Computed property para obtener el enum
    var estadoEnum: EstadoSolicitud {
        EstadoSolicitud(rawValue: estado) ?? .pendiente
    }
    
    enum EstadoSolicitud: String, Codable {
        case pendiente = "pendiente"
        case enRevision = "en_revision"
        case aprobada = "aprobada"
        case rechazada = "rechazada"
        
        var displayName: String {
            switch self {
            case .pendiente: return LocalizedKey.pending.localized
            case .enRevision: return LocalizedKey.inReview.localized
            case .aprobada: return LocalizedKey.approved.localized
            case .rechazada: return LocalizedKey.rejected.localized
            }
        }
        
        var color: String {
            switch self {
            case .pendiente: return "orange"
            case .enRevision: return "blue"
            case .aprobada: return "green"
            case .rechazada: return "red"
            }
        }
    }
}

