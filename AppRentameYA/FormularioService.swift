//
//  FormularioService.swift
//  AppRentameYA
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import UIKit

@MainActor
class FormularioService: ObservableObject {
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var solicitudEnviada = false
    
    /// Verifica si el usuario actual ya tiene una solicitud pendiente o aprobada
    func verificarSolicitudExistente() async -> Bool {
        guard let userId = Auth.auth().currentUser?.uid else {
            return false
        }
        
        do {
            let snapshot = try await db.collection("solicitudes")
                .whereField("userId", isEqualTo: userId)
                .whereField("estado", in: ["pendiente", "en_revision", "aprobada"])
                .limit(to: 1)
                .getDocuments()
            
            return !snapshot.documents.isEmpty
        } catch {
            print("Error al verificar solicitud existente: \(error.localizedDescription)")
            return false
        }
    }
    
    /// Sube la imagen de la licencia a Firebase Storage
    private func subirLicencia(_ imagen: UIImage, userId: String) async throws -> String {
        guard let imageData = imagen.jpegData(compressionQuality: 0.8) else {
            throw NSError(domain: "FormularioService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Error al convertir imagen"])
        }
        
        // Limpiar el userId para evitar caracteres problemáticos en el nombre del archivo
        let cleanUserId = userId.replacingOccurrences(of: "/", with: "_").replacingOccurrences(of: " ", with: "_")
        let uuid = UUID().uuidString
        let fileName = "licencias/\(cleanUserId)/\(uuid).jpg"
        let storageRef = storage.reference().child(fileName)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        // Agregar metadata personalizada para facilitar la búsqueda
        metadata.customMetadata = ["userId": cleanUserId, "uploadedAt": "\(Date().timeIntervalSince1970)"]
        
        print("📤 Subiendo imagen a: \(fileName)")
        print("📏 Tamaño de imagen: \(imageData.count) bytes")
        
        // Subir el archivo
        do {
            let uploadMetadata = try await storageRef.putDataAsync(imageData, metadata: metadata)
            print("✅ Imagen subida exitosamente")
            print("📋 Metadata recibida: path=\(uploadMetadata.path ?? "nil"), size=\(uploadMetadata.size)")
            
            // Esperar un momento para que el archivo esté completamente disponible
            try await Task.sleep(nanoseconds: 500_000_000) // 0.5 segundos
            
            // Intentar obtener la URL con reintentos
            var downloadURL: URL?
            var lastError: Error?
            
            for attempt in 1...3 {
                do {
                    downloadURL = try await storageRef.downloadURLAsync()
                    print("🔗 URL obtenida en intento \(attempt): \(downloadURL?.absoluteString ?? "nil")")
                    break
                } catch {
                    lastError = error
                    print("⚠️ Intento \(attempt) falló: \(error.localizedDescription)")
                    if attempt < 3 {
                        // Esperar un poco más antes del siguiente intento
                        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 segundo
                    }
                }
            }
            
            guard let finalURL = downloadURL else {
                // Si no podemos obtener la URL, construirla manualmente
                let bucket = storage.app.options.storageBucket ?? ""
                let constructedURL = "https://firebasestorage.googleapis.com/v0/b/\(bucket)/o/\(fileName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? fileName)?alt=media"
                print("🔗 Usando URL construida: \(constructedURL)")
                return constructedURL
            }
            
            return finalURL.absoluteString
            
        } catch {
            print("❌ Error completo al subir/licencia: \(error.localizedDescription)")
            throw NSError(
                domain: "FormularioService",
                code: 4,
                userInfo: [NSLocalizedDescriptionKey: "Error al subir la imagen: \(error.localizedDescription). Verifica que Storage esté habilitado y las reglas de seguridad estén configuradas correctamente."]
            )
        }
    }
    
    /// Guarda la solicitud en Firestore
    func enviarSolicitud(
        vehiculoNombre: String,
        nombreCompleto: String,
        telefono: String,
        licenciaFrente: UIImage
    ) async throws {
        guard let userId = Auth.auth().currentUser?.uid,
              let userEmail = Auth.auth().currentUser?.email else {
            throw NSError(domain: "FormularioService", code: 2, userInfo: [NSLocalizedDescriptionKey: "Usuario no autenticado"])
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            // Verificar si ya tiene una solicitud
            let tieneSolicitud = await verificarSolicitudExistente()
            if tieneSolicitud {
                throw NSError(domain: "FormularioService", code: 3, userInfo: [NSLocalizedDescriptionKey: "Ya tienes una solicitud pendiente. No puedes enviar otra hasta que se procese la actual."])
            }
            
            // Subir imagen de licencia
            let licenciaURL = try await subirLicencia(licenciaFrente, userId: userId)
            
            // Crear documento de solicitud
            let solicitudData: [String: Any] = [
                "userId": userId,
                "userEmail": userEmail,
                "vehiculoNombre": vehiculoNombre,
                "nombreCompleto": nombreCompleto,
                "telefono": telefono,
                "licenciaURL": licenciaURL,
                "estado": "pendiente",
                "fechaCreacion": FieldValue.serverTimestamp(),
                "fechaActualizacion": FieldValue.serverTimestamp()
            ]
            
            // Guardar en Firestore
            _ = try await db.collection("solicitudes").addDocument(data: solicitudData)
            
            solicitudEnviada = true
            isLoading = false
            
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
            throw error
        }
    }
}

// Extensión para hacer putDataAsync compatible con async/await
extension StorageReference {
    func putDataAsync(_ data: Data, metadata: StorageMetadata?) async throws -> StorageMetadata {
        return try await withCheckedThrowingContinuation { continuation in
            self.putData(data, metadata: metadata) { metadata, error in
                if let error = error {
                    print("❌ Error al subir archivo: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                } else if let metadata = metadata {
                    continuation.resume(returning: metadata)
                } else {
                    continuation.resume(throwing: NSError(domain: "Storage", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error desconocido al subir archivo"]))
                }
            }
        }
    }
    
    func downloadURLAsync() async throws -> URL {
        return try await withCheckedThrowingContinuation { continuation in
            self.downloadURL { url, error in
                if let error = error {
                    print("❌ Error al obtener URL: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                } else if let url = url {
                    continuation.resume(returning: url)
                } else {
                    continuation.resume(throwing: NSError(domain: "Storage", code: -2, userInfo: [NSLocalizedDescriptionKey: "No se pudo obtener la URL de descarga"]))
                }
            }
        }
    }
}

