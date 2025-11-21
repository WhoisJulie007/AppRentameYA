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
                            .frame(height: geometry.size.height) // 70% de la pantalla
                            .onAppear {
                                player.play()
                            }
                    } else {
                        // Placeholder mientras se carga el video
                        Color.black
                            .frame(height: geometry.size.height * 0.7)
                    }
                    
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

#Preview {
    SplashScreenView(showSplash: .constant(true))
}
