import Foundation

struct VehiculoModel: Identifiable {
    var id: String?
    var nombre: String
    var precioSemanaMXN: Int
    var caracteristicas: [String]

    init(id: String? = nil,
         nombre: String,
         precioSemanaMXN: Int,
         caracteristicas: [String]) {
        self.id = id
        self.nombre = nombre
        self.precioSemanaMXN = precioSemanaMXN
        self.caracteristicas = caracteristicas
    }
}
