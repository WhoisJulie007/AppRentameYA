//
//  FormularioModel.swift
//  AppRentameYA
//

import SwiftUI

struct FormularioModel: Equatable {
    var vehiculoNombre: String
    var nombreCompleto: String = ""
    var telefono: String = ""
    var licenciaFrente: UIImage? = nil
}

extension FormularioModel {
    var telefonoSoloDigitos: String { telefono.filter(\.isNumber) }
}
