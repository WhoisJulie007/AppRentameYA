//
//  VehiculosView.swift
//  AppRentameYA
//

import SwiftUI

struct VehiculosView: View {
    var body: some View {
        NavigationStack {                           // <- importante
            VStack(spacing: 0) {
                // Encabezado
                VStack(alignment: .leading, spacing: 8) {
                    Text("Vehículos")
                        .font(.largeTitle).bold()
                    Divider()
                }
                .padding(.horizontal)
                .padding(.top, 8)

                // Lista de tarjetas
                ScrollView {
                    LazyVStack(spacing: 18) {
                        ForEach(Vehiculos.lista) { item in
                            CarroCardView(
                                nombre: item.nombre,
                                precio: item.precioSemanaMXN,
                                periodo: "semana",
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
                
                // Tab bar inferior
                VStack(spacing: 4) {
                    Divider()
                    HStack {
                        Spacer()
                        TabBarItemVisual(title: "Inicio", imageName: "house.fill", isSelected: false)
                        Spacer()
                        TabBarItemVisual(title: "Vehículos", imageName: "car.fill", isSelected: true)
                        Spacer()
                        TabBarItemVisual(title: "Perfil", imageName: "person.fill", isSelected: false)
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    .background(Color.white)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    VehiculosView()   // el NavigationStack ya viene dentro
}
