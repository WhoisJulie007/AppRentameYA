//
//  InfoBanner.swift
//  AppRentameYA
//

import SwiftUI

struct InfoBanner: View {
    let texto: String
    var color: Color = .blue
    var mostrarTitulo: Bool = true
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: color == .orange ? "exclamationmark.triangle.fill" : "info.circle.fill")
                .font(.title3)
                .foregroundColor(color)
            Text(mostrarTitulo ? AttributedString("**Depósito en garantía:** \(texto)") : AttributedString(texto))
                .font(.subheadline)
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}
