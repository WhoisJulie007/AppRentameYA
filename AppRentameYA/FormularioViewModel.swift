//
//  FormularioViewModel.swift
//  AppRentameYA
//

import SwiftUI
import Combine

@MainActor
final class FormularioViewModel: ObservableObject {
    @Published var form: FormularioModel
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var solicitudEnviada = false
    @Published var yaTieneSolicitud = false
    
    private let formularioService = FormularioService()
    
    init(vehiculoNombre: String) {
        self.form = .init(vehiculoNombre: vehiculoNombre)
        Task {
            await verificarSolicitudExistente()
        }
    }
    
    // Validaciones básicas
    var nombreValido: Bool { form.nombreCompleto.trimmingCharacters(in: .whitespaces).count >= 3 }
    var telefonoValido: Bool { form.telefonoSoloDigitos.count == 10 }
    var licenciaSubida: Bool { form.licenciaFrente != nil }
    
    var puedeEnviar: Bool { 
        !yaTieneSolicitud && nombreValido && telefonoValido && licenciaSubida && !isLoading
    }
    
    /// Verifica si el usuario ya tiene una solicitud pendiente
    func verificarSolicitudExistente() async {
        yaTieneSolicitud = await formularioService.verificarSolicitudExistente()
    }
    
    /// Envía la solicitud a Firebase
    func enviar() {
        guard let licencia = form.licenciaFrente else {
            errorMessage = "Por favor, sube una foto de tu licencia"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                try await formularioService.enviarSolicitud(
                    vehiculoNombre: form.vehiculoNombre,
                    nombreCompleto: form.nombreCompleto.trimmingCharacters(in: .whitespacesAndNewlines),
                    telefono: form.telefonoSoloDigitos,
                    licenciaFrente: licencia
                )
                
                solicitudEnviada = true
                isLoading = false
            } catch {
                isLoading = false
                errorMessage = error.localizedDescription
            }
        }
    }
}

private extension FormularioModel {
    var formattedNombre: String { nombreCompleto.trimmingCharacters(in: .whitespacesAndNewlines) }
}
