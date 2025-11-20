# 📦 Pasos Detallados para Agregar Firebase Storage

## 🎯 Paso 1: Agregar Firebase Storage en Xcode

### Método Recomendado (Editar paquete existente):

1. **Abre Xcode** con tu proyecto `AppRentameYA`

2. **En el navegador de archivos izquierdo**, haz clic en el **icono azul del proyecto** (el más arriba, llamado "AppRentameYA")

3. **En el panel central**, verás varias pestañas. Haz clic en **"Package Dependencies"** (Dependencias de Paquetes)

4. **Busca en la lista** el paquete llamado **"firebase-ios-sdk"** (debería estar ahí)

5. **Haz clic derecho** en "firebase-ios-sdk" o busca un botón **"+"** o **"Edit"** junto a él

6. **Se abrirá una ventana** con una lista de productos. Busca y marca la casilla de:
   - ✅ **FirebaseStorage** ← **ESTE ES EL IMPORTANTE**

7. **Haz clic en "Add Package"** o "Done"

8. **Espera** a que Xcode descargue e instale Firebase Storage (verás un indicador de progreso)

### Método Alternativo (Si no puedes editar el paquete):

1. Ve a **File > Add Packages...** (o ⌘⇧⌥P)

2. En la barra de búsqueda, escribe: `https://github.com/firebase/firebase-ios-sdk`

3. Selecciona el paquete y haz clic en **"Add Package"**

4. En la pantalla de selección de productos, marca:
   - ✅ FirebaseCore
   - ✅ FirebaseAuth  
   - ✅ FirebaseFirestore
   - ✅ FirebaseAppCheck
   - ✅ **FirebaseStorage** ← **AGREGAR ESTE**

5. Haz clic en **"Add Package"**

---

## ✅ Paso 2: Verificar que se agregó correctamente

1. **Compila el proyecto** (⌘B)

2. **Si NO ves el error** "No such module 'FirebaseStorage'", ¡perfecto! ✅

3. Si aún ves el error, espera unos segundos y vuelve a compilar (a veces Xcode tarda en actualizar)

---

## 🔧 Paso 3: Actualizar el código

Una vez que Firebase Storage esté agregado, necesitas actualizar `FormularioService.swift`:

### Cambios a realizar:

1. **Descomenta la línea 9:**
   ```swift
   import FirebaseStorage  // ← Quitar el // del inicio
   ```

2. **Descomenta la línea 17:**
   ```swift
   private let storage = Storage.storage()  // ← Quitar el // del inicio
   ```

3. **Reemplaza el método `subirLicencia`** (líneas 99-105) con la versión que usa Storage (está comentada más abajo, líneas 60-80)

4. **Comenta o elimina** los métodos temporales:
   - `convertirImagenABase64` (líneas 67-95)
   - `redimensionarImagen` (líneas 43-63) - puedes dejarlo si quieres

5. **Descomenta la extensión `StorageReference`** al final del archivo (líneas 135-152)

---

## 📝 Resumen de cambios en FormularioService.swift

**ANTES (con base64 - temporal):**
```swift
// import FirebaseStorage  ← Comentado
// private let storage = Storage.storage()  ← Comentado
private func convertirImagenABase64(...)  ← Usando este
private func subirLicencia(...) { 
    // Versión base64
}
```

**DESPUÉS (con Storage - correcto):**
```swift
import FirebaseStorage  ← Descomentado
private let storage = Storage.storage()  ← Descomentado
private func subirLicencia(...) { 
    // Versión que sube a Storage
    let storageRef = storage.reference().child(fileName)
    // ... código de Storage
}
// convertirImagenABase64  ← Ya no se necesita
```

---

## 🚀 Paso 4: Configurar Firebase Storage en la Consola

1. Ve a [Firebase Console](https://console.firebase.google.com/)

2. Selecciona tu proyecto

3. Ve a **Storage** en el menú lateral

4. Si no está habilitado, haz clic en **"Get started"**

5. Configura las reglas de seguridad (copia y pega esto en Storage > Rules):

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Permitir lectura/escritura solo a usuarios autenticados para sus propias licencias
    match /licencias/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

6. Haz clic en **"Publish"**

---

## ✨ ¡Listo!

Después de estos pasos:
- ✅ Firebase Storage estará agregado al proyecto
- ✅ Las imágenes se subirán a Storage (no a Firestore)
- ✅ No habrá límites de tamaño de imagen
- ✅ El código funcionará correctamente

**Prueba enviando una solicitud desde la app para verificar que todo funciona.**

