//
//  FormularioViewModel.swift
//  AppRentameYA
//

import SwiftUI
import Combine

final class FormularioViewModel: ObservableObject {
    @Published var form: FormularioModel
    
    init(vehiculoNombre: String) {
        self.form = .init(vehiculoNombre: vehiculoNombre)
    }
    
    // Validaciones básicas
    var nombreValido: Bool { form.nombreCompleto.trimmingCharacters(in: .whitespaces).count >= 3 }
    var telefonoValido: Bool { form.telefonoSoloDigitos.count == 10 }
    var licenciaSubida: Bool { form.licenciaFrente != nil }
    
    var puedeEnviar: Bool { nombreValido && telefonoValido && licenciaSubida }
    
    func enviar() {
        // Aquí integrarías tu lógica: subir archivos, enviar a API, etc.
        print("Enviando aplicación para \(form.vehiculoNombre)")
        print("Nombre: \(form.formattedNombre), Tel: \(form.telefonoSoloDigitos)")
    }
}

private extension FormularioModel {
    var formattedNombre: String { nombreCompleto.trimmingCharacters(in: .whitespacesAndNewlines) }
}
