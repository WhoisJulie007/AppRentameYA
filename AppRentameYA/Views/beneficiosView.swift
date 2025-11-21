//
//  beneficiosView.swift
//  AppRentameYA
//
//  Created by Maydeli Castan on 29/10/25.
//

import SwiftUI

struct BenefitRow: View {
    var text: String
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "checkmark.circle")
                .foregroundColor(.green)
                .font(.system(size: 18))
                .padding(.top, 2)
            Text(text)
                .font(.system(size: 16))
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    BenefitRow(text: "Seguro de cobertura amplia incluido.")
}
