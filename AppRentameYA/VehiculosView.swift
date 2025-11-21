//
//  VehiculosView.swift
//  AppRentameYA
//

import SwiftUI
import FirebaseFirestore // No estrictamente necesario aquí si el manager lo maneja todo, pero es buena práctica.

struct VehiculosView: View {
    // Declara una instancia de tu FirestoreManager usando @StateObject.
    // Esto asegura que el manager se cree una sola vez y persista durante la vida de la vista.
    @StateObject var firestoreManager = FirestoreManager()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Encabezado
                VStack(alignment: .leading, spacing: 8) {
                    Text(LocalizedKey.vehiculos.localized)
                        .font(.largeTitle).bold()
                    Divider()
                }
                .padding(.horizontal)
                .padding(.top, 8)

                // Lista de tarjetas
                ScrollView {
                    LazyVStack(spacing: 18) {
                        // Ahora iteras sobre la lista 'vehiculos' que gestiona tu FirestoreManager.
                        // Cada vez que firestoreManager.vehiculos cambie, la vista se actualizará.
                        ForEach(firestoreManager.vehiculos) { item in
                            CarroCardView(
                                nombre: item.nombre,
                                precio: item.precioSemanaMXN,
                                periodo: "semana", // Asumo que esto sigue siendo un valor fijo o vendrá de tu modelo.
                                caracteristicas: item.caracteristicas
                            )
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical, 12)
                    .padding(.bottom, 88) // espacio para no chocar con el tab bar
                }
                .background(Color(.systemGroupedBackground))
                
                // Tab bar inferior (manteniéndolo igual)
                
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            // Cuando la vista aparece, llama al método para obtener los vehículos.
            // El addSnapshotListener mantendrá la lista actualizada en tiempo real.
            .onAppear {
                firestoreManager.getVehiculos()
            }
        }
    }
}

// Asegúrate de que CarroCardView y TabBarItemVisual estén definidos en tu proyecto.
// #Preview solo para Xcode Canvas
#Preview {
    VehiculosView()
}
