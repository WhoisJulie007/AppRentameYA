//
//  CarroCardView.swift
//  AppRentameYA
//
//  Created by Maydeli Castan on 29/10/25.
//

import SwiftUI

struct CarroCardView: View {
    var nombre: String
    var precio: Int
    var periodo: String
    var caracteristicas: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            // Título
            Text(nombre)
                .font(.headline)
                .bold()
            
            // Precio
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text("$\(precio) MXN")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                Text("/ \(LocalizedKey.week.localized)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            // Lista de características
            VStack(alignment: .leading, spacing: 4) {
                ForEach(caracteristicas, id: \.self) { item in
                    HStack {
                        Image(systemName: "checkmark")
                        Text(item)
                    }
                    .font(.subheadline)
                }
            }
            
            Spacer()
            
            NavigationLink(destination: FormularioView(vehiculoNombre: nombre)) {
                Text(LocalizedKey.applyNow.localized)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
            }

            
        }
        .padding()
        .frame(width: 350, height: 250)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 6, x: 0, y: 2)

    }
}

#Preview {
    NavigationStack {
        CarroCardView(
            nombre: "Nissan Versa",
            precio: 2100,
            periodo: "semana",
            caracteristicas: ["Automático","Aire Acondicionado","Amplia cajuela"]
        )
    }
}

