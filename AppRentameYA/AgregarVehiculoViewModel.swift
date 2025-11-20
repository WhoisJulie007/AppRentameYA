//
//  AgregarVehiculoViewModel.swift
//  AppRentameYA
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
class AgregarVehiculoViewModel: ObservableObject {
    @Published var nombre: String = ""
    @Published var precioTexto: String = ""
    @Published var caracteristicas: [String] = []
    @Published var nuevaCaracteristica: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var vehiculoGuardado = false
    
    private let db = Firestore.firestore()
    private let adminEmail = "maydeli.castan@iest.edu.mx"
    
    var precio: Int? {
        Int(precioTexto)
    }
    
    var puedeGuardar: Bool {
        !nombre.trimmingCharacters(in: .whitespaces).isEmpty &&
        precio != nil &&
        precio! > 0 &&
        !caracteristicas.isEmpty
    }
    
    func guardarVehiculo(firestoreManager: FirestoreManager) async {
        // Verificar que es admin
        guard Auth.auth().currentUser?.email == adminEmail else {
            errorMessage = "Solo los administradores pueden agregar vehículos"
            return
        }
        
        guard let precioValor = precio else {
            errorMessage = "El precio debe ser un número válido"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let vehiculoData: [String: Any] = [
                "nombre": nombre.trimmingCharacters(in: .whitespaces),
                "precioSemanaMXN": precioValor,
                "caracteristicas": caracteristicas
            ]
            
            _ = try await db.collection("vehiculos").addDocument(data: vehiculoData)
            
            // Refrescar la lista de vehículos
            firestoreManager.getVehiculos()
            
            vehiculoGuardado = true
            isLoading = false
            
            // Limpiar el formulario
            nombre = ""
            precioTexto = ""
            caracteristicas = []
            nuevaCaracteristica = ""
            
        } catch {
            isLoading = false
            errorMessage = "Error al guardar el vehículo: \(error.localizedDescription)"
        }
    }
}

