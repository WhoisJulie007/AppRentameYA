import Foundation
import FirebaseFirestore

class FirestoreManager: ObservableObject {

    private let db = Firestore.firestore()

    @Published var vehiculos: [VehiculoModel] = []

    func getVehiculos() {
        db.collection("vehiculos")
            .order(by: "nombre")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    print("Error al obtener vehículos: \(error.localizedDescription)")
                    return
                }

                // 👇 Aquí forzamos el tipo [VehiculoModel]
                let nuevos: [VehiculoModel] = snapshot?.documents.compactMap { doc -> VehiculoModel? in
                    let data = doc.data()

                    let nombre = data["nombre"] as? String ?? ""
                    let precio = data["precioSemanaMXN"] as? Int ?? 0
                    let caracteristicas = data["caracteristicas"] as? [String] ?? []

                    return VehiculoModel(
                        id: doc.documentID,
                        nombre: nombre,
                        precioSemanaMXN: precio,
                        caracteristicas: caracteristicas
                    )
                } ?? []

                DispatchQueue.main.async {
                    self.vehiculos = nuevos
                    print("Vehículos actualizados desde Firestore. Total: \(self.vehiculos.count)")
                }
            }
    }
}
