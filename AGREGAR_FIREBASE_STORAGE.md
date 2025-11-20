# Cómo Agregar Firebase Storage al Proyecto

## Pasos para Agregar Firebase Storage en Xcode

### Opción 1: Agregar desde el Package Manager (Recomendado)

1. **Abre tu proyecto en Xcode**

2. **Selecciona el proyecto** en el navegador de archivos (el icono azul en la parte superior)

3. **Selecciona el target "AppRentameYA"** en la lista de targets

4. **Ve a la pestaña "Package Dependencies"**

5. **Busca el paquete "firebase-ios-sdk"** en la lista (ya debería estar agregado)

6. **Haz clic en el paquete** y luego haz clic en el botón **"Edit"** o **"+"** si no está visible

7. **En la lista de productos**, busca y marca la casilla de **"FirebaseStorage"**

8. **Haz clic en "Done"** o "Add Package"

9. **Espera a que Xcode resuelva las dependencias** (puede tomar unos segundos)

10. **Compila el proyecto** (⌘B) para verificar que todo funciona

### Opción 2: Si el paquete no aparece en la lista

Si no ves el paquete firebase-ios-sdk en la lista:

1. Ve a **File > Add Packages...**

2. En el campo de búsqueda, escribe: `https://github.com/firebase/firebase-ios-sdk`

3. Selecciona la versión (recomendado: "Up to Next Major Version" con 12.5.0 o superior)

4. Haz clic en **"Add Package"**

5. En la pantalla de selección de productos, marca:
   - ✅ FirebaseCore (ya debería estar)
   - ✅ FirebaseAuth (ya debería estar)
   - ✅ FirebaseFirestore (ya debería estar)
   - ✅ FirebaseAppCheck (ya debería estar)
   - ✅ **FirebaseStorage** ← **AGREGAR ESTE**

6. Haz clic en **"Add Package"**

## Después de Agregar Firebase Storage

Una vez que hayas agregado Firebase Storage:

1. **Abre `FormularioService.swift`**

2. **Descomenta las líneas marcadas con `// TODO:`**:
   - Línea 8: `import FirebaseStorage`
   - Línea 15: `private let storage = Storage.storage()`
   - El método `subirLicencia` completo (líneas comentadas al final del archivo)
   - La extensión `StorageReference` (al final del archivo)

3. **Elimina o comenta** el método temporal `convertirImagenABase64` y el método `subirLicencia` que usa base64

4. **Compila el proyecto** para verificar que todo funciona

## Verificación

Para verificar que Firebase Storage está correctamente agregado:

1. Compila el proyecto (⌘B)
2. No deberías ver el error "No such module 'FirebaseStorage'"
3. El proyecto debería compilar sin errores

## Nota Importante

La versión actual del código usa **base64** para guardar las imágenes directamente en Firestore. Esto funciona, pero tiene limitaciones:
- Las imágenes base64 ocupan más espacio
- Firestore tiene un límite de 1MB por documento
- No es la solución ideal para producción

**Recomendación**: Agrega Firebase Storage lo antes posible para usar la versión optimizada del código.

