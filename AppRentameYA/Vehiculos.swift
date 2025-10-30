//
//  Vehiculos.swift
//  AppRentameYA
//
//  Created by Maydeli Castan on 29/10/25.
//

import Foundation

struct Vehiculos {
    static let lista: [VehiculoModel] = [
        VehiculoModel(
            nombre: "Nissan Versa",
            precioSemanaMXN: 2100,
            caracteristicas: [
                "Automático",
                "Aire Acondicionado",
                "Amplia cajuela"
            ]
        ),
        VehiculoModel(
            nombre: "Chevrolet Onix",
            precioSemanaMXN: 1950,
            caracteristicas: [
                "Manual",
                "Alto rendimiento",
                "Conectividad Bluetooth"
            ]
        ),
        VehiculoModel(
            nombre: "Kia Rio Hatchback",
            precioSemanaMXN: 2300,
            caracteristicas: [
                "Automático",
                "Pantalla táctil",
                "Sensores de reversa"
            ]
        )
    ]
}
