//
//  InfoBanner.swift
//  AppRentameYA
//

import SwiftUI

struct InfoBanner: View {
    let texto: String
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "info.circle.fill")
                .font(.title3)
                .foregroundColor(.blue)
            Text(AttributedString("**Depósito en garantía:** \(texto)"))
                .font(.subheadline)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
