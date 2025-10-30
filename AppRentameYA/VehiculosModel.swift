//
//  VehiculoModel.swift
//  AppRentameYA
//
//  Created by Maydeli Castan on 29/10/25.
//

import Foundation

struct VehiculoModel: Identifiable, Hashable {
    let id = UUID()
    let nombre: String
    let precioSemanaMXN: Int
    let caracteristicas: [String]
}
