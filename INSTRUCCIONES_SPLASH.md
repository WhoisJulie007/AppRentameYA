# 🎬 Instrucciones para la Pantalla de Splash

## ✅ Implementación Completada

He creado la pantalla de splash que:
1. ✅ Muestra un video al iniciar la app
2. ✅ Muestra un GIF de carga debajo del video
3. ✅ Navega automáticamente a la pantalla de inicio cuando el video termina

## 📁 Archivos Creados

- **SplashScreenView.swift** - Vista principal del splash screen
- **AppRentameYAApp.swift** - Actualizado para mostrar el splash primero

## 🎥 Configuración del Video

El código intenta cargar el video desde `Assets.xcassets/video.dataset/video.mp4`.

### Si el video NO se carga correctamente:

Si encuentras que el video no se reproduce, puedes mover el video fuera de Assets.xcassets:

1. **Mover el video al bundle principal:**
   - En Xcode, arrastra `video.mp4` directamente a la carpeta `AppRentameYA` (no dentro de Assets.xcassets)
   - Asegúrate de que esté marcado como "Copy items if needed" y agregado al target

2. **Actualizar el código en SplashScreenView.swift:**
   
   Cambia la función `setupVideo()` para usar:
   
   ```swift
   private func setupVideo() {
       // Cargar el video desde el bundle principal
       guard let videoURL = Bundle.main.url(forResource: "video", withExtension: "mp4") else {
           print("❌ No se encontró el video en el bundle")
           videoFinished = true
           return
       }
       
       let playerItem = AVPlayerItem(url: videoURL)
       let newPlayer = AVPlayer(playerItem: playerItem)
       newPlayer.isMuted = true
       
       // ... resto del código igual
   }
   ```

## 🎨 Configuración del GIF

El GIF se carga desde `Assets.xcassets/cargando.dataset/cargando.gif`.

### Si el GIF NO se carga correctamente:

1. **Mover el GIF al bundle principal:**
   - Arrastra `cargando.gif` directamente a la carpeta `AppRentameYA`
   - Asegúrate de que esté agregado al target

2. **Actualizar el código:**
   
   Cambia `GIFViewFromAsset` para usar:
   
   ```swift
   private func loadGIF(into imageView: UIImageView) {
       guard let gifURL = Bundle.main.url(forResource: "cargando", withExtension: "gif"),
             let gifData = try? Data(contentsOf: gifURL) else {
           print("❌ No se pudo cargar el GIF")
           return
       }
       // ... resto del código igual
   }
   ```

## 🔧 Verificación

1. **Compila y ejecuta la app**
2. **Deberías ver:**
   - El video reproduciéndose en pantalla completa
   - El GIF de carga debajo del video
   - Al terminar el video, transición automática a la pantalla de inicio/welcome

## 🐛 Solución de Problemas

### El video no se reproduce:
- Verifica que el video esté en el formato correcto (MP4)
- Verifica que el video no sea demasiado grande (recomendado < 10MB)
- Revisa la consola de Xcode para ver mensajes de error

### El GIF no se muestra:
- Verifica que el GIF esté en formato GIF
- Revisa que el nombre del asset sea exactamente "cargando"

### La app se queda en el splash:
- Verifica que el video termine correctamente
- Revisa los logs en la consola
- Si el video no se carga, se saltará automáticamente después de un momento

## 📝 Notas

- El video se reproduce **sin sonido** (muted) por defecto
- El video se limpia automáticamente después de reproducirse
- Si el video no se encuentra, la app continuará automáticamente
- El GIF se anima infinitamente hasta que el video termine

