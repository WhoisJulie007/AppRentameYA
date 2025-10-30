//
//  tabBarItemView.swift
//  AppRentameYA
//
//  Created by Maydeli Castan on 29/10/25.
//

import SwiftUI

struct TabBarItemVisual: View {
    let title: String
    let imageName: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: imageName)
                .font(.system(size: 20))
            Text(title)
                .font(.caption2)
        }
        .foregroundColor(isSelected ? .blue : .gray)
    }
}
#Preview {
    TabBarItemVisual(title: "Inicio", imageName: "house.fill", isSelected: true)
}
