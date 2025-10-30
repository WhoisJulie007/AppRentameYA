//
//  DashedDropZone.swift
//  AppRentameYA
//

import SwiftUI
import PhotosUI

struct DashedDropZone: View {
    @Binding var image: UIImage?
    @State private var item: PhotosPickerItem?
    
    var title: String = "Sube un archivo o arrástralo aquí"
    
    var body: some View {
        VStack(spacing: 8) {
            if let ui = image {
                Image(uiImage: ui)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 120)
                    .cornerRadius(8)
            } else {
                Image(systemName: "photo.on.rectangle.angled")
                    .font(.system(size: 36))
                    .foregroundColor(.gray)
                PhotosPicker(selection: $item, matching: .images) {
                    Text("Sube un archivo")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .underline()
                }
                Text("o arrástralo aquí")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 150)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(style: StrokeStyle(lineWidth: 2, dash: [6]))
                .foregroundColor(Color.gray.opacity(0.5))
        )
        .onChange(of: item) { _, new in
            guard let new else { return }
            Task {
                if let data = try? await new.loadTransferable(type: Data.self),
                   let ui = UIImage(data: data) {
                    await MainActor.run { image = ui }
                }
            }
        }
        .onDrop(of: [.image, .fileURL, .png, .jpeg, .heic], isTargeted: nil) { providers in
            if let provider = providers.first(where: { $0.canLoadObject(ofClass: UIImage.self) }) {
                _ = provider.loadObject(ofClass: UIImage.self) { obj, _ in
                    if let ui = obj as? UIImage {
                        DispatchQueue.main.async { image = ui }
                    }
                }
                return true
            }
            return false
        }
    }
}
