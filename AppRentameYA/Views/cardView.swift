//
//  cardView.swift
//  AppRentameYA
//
//  Created by Maydeli Castan on 29/10/25.
//

import SwiftUI

struct CardView<Content: View>: View {
    var background: Color = .white
    var borderColor: Color? = nil
    var cornerRadius: CGFloat = 18
    @ViewBuilder var content: Content

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(background)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .stroke(borderColor ?? .clear, lineWidth: borderColor == nil ? 0 : 1.5)
                )
                .shadow(color: .black.opacity(0.05), radius: 8, y: 4)

            content
                .padding(16)
        }
    }
}

#Preview {
    CardView {
        VStack(alignment: .leading, spacing: 8) {
            Text("¡Hola, Conductor!")
                .font(.system(.title3, design: .rounded).weight(.bold))
            Text("Bienvenido a tu centro de control. Aquí podrás ver el estado de tu vehículo y encontrar tu próximo auto para seguir ganando.")
                .font(.system(size: 16))
                .foregroundStyle(.secondary)
        }
    }
}
