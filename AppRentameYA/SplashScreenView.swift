//
//  SplashScreenView.swift
//  AppRentameYA
//

import SwiftUI
import AVKit
import AVFoundation

struct SplashScreenView: View {
    @State private var player: AVPlayer?
    @State private var videoFinished = false
    @Binding var showSplash: Bool
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // Parte superior: Video
                    if let player = player {
                        VideoPlayer(player: player)
                            .frame(height: geometry.size.height * 0.7) // 70% de la pantalla
                            .onAppear {
                                player.play()
                            }
                    } else {
                        // Placeholder mientras se carga el video
                        Color.black
                            .frame(height: geometry.size.height * 0.7)
                    }
                    
                    // Parte inferior: GIF centrado
                    VStack {
                        Spacer()
                        VStack {
                            Spacer()
                            GIFViewFromAsset(size: 50)
                                .padding(175.0)
                                .frame(maxWidth: .infinity, alignment: .center) // Centrado horizontal
                            Spacer()
                        }
                        Spacer()
                    }
                    .frame(height: geometry.size.height * 0.3) // 30% de la pantalla
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
        .onAppear {
            setupVideo()
        }
        .onChange(of: videoFinished) { finished in
            if finished {
                // Esperar un momento antes de ocultar el splash
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation {
                        showSplash = false
                    }
                }
            }
        }
    }

    private func setupVideo() {
        // Intentar cargar el video desde Assets.xcassets usando NSDataAsset
        guard let videoAsset = NSDataAsset(name: "video"),
              let videoData = videoAsset.data as Data? else {
            print("❌ No se encontró el video en Assets")
            // Si no se encuentra, marcar como terminado inmediatamente
            videoFinished = true
            return
        }
        
        // Crear un archivo temporal para el video
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("splash_video.mp4")
        
        do {
            try videoData.write(to: tempURL)
        } catch {
            print("❌ Error al escribir el video temporal: \(error.localizedDescription)")
            videoFinished = true
            return
        }
        
        let playerItem = AVPlayerItem(url: tempURL)
        let newPlayer = AVPlayer(playerItem: playerItem)
        
        // Reproducir con sonido
        newPlayer.isMuted = false
        
        // Observar cuando el video termine
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: playerItem,
            queue: .main
        ) { _ in
            // Limpiar el archivo temporal
            try? FileManager.default.removeItem(at: tempURL)
            videoFinished = true
        }
        
        // Observar el estado del video usando un Timer para verificar el estado
        var statusTimer: Timer?
        statusTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if playerItem.status == .readyToPlay {
                timer.invalidate()
                statusTimer = nil
            } else if playerItem.status == .failed {
                print("❌ Error al cargar el video: \(playerItem.error?.localizedDescription ?? "Desconocido")")
                timer.invalidate()
                statusTimer = nil
                try? FileManager.default.removeItem(at: tempURL)
                videoFinished = true
            }
        }
        
        self.player = newPlayer
    }
}

// Vista para mostrar GIF desde Assets.xcassets
struct GIFViewFromAsset: UIViewRepresentable {
    let size: CGFloat
    
    func makeUIView(context: Context) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        loadGIF(into: imageView)
        
        containerView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalToConstant: size),
            containerView.heightAnchor.constraint(equalToConstant: size),
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: size),
            imageView.heightAnchor.constraint(equalToConstant: size)
        ])
        
        return containerView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // No necesitamos actualizar
    }
    
    private func loadGIF(into imageView: UIImageView) {
        // Cargar el GIF desde Assets.xcassets
        guard let gifAsset = NSDataAsset(name: "cargando"),
              let gifData = gifAsset.data as Data? else {
            print("❌ No se pudo cargar el GIF desde Assets")
            // Mostrar un indicador de carga alternativo
            imageView.image = UIImage(systemName: "arrow.2.circlepath")
            imageView.tintColor = .white
            return
        }
        
        guard let source = CGImageSourceCreateWithData(gifData as CFData, nil) else {
            print("❌ No se pudo crear el source del GIF")
            return
        }
        
        let count = CGImageSourceGetCount(source)
        var images: [UIImage] = []
        var totalDuration: TimeInterval = 0
        
        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let image = UIImage(cgImage: cgImage)
                images.append(image)
                
                if let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? [String: Any],
                   let gifProperties = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any],
                   let delayTime = gifProperties[kCGImagePropertyGIFDelayTime as String] as? Double {
                    totalDuration += delayTime
                }
            }
        }
        
        if !images.isEmpty {
            imageView.animationImages = images
            imageView.animationDuration = totalDuration > 0 ? totalDuration : 1.0
            imageView.animationRepeatCount = 0 // Infinito
            imageView.startAnimating()
        }
    }
}

#Preview {
    SplashScreenView(showSplash: .constant(true))
}
