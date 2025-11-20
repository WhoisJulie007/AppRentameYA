# 🔧 Solución al Error "Object does not exist"

## El Problema

El error "Object licencias/... does not exist" generalmente ocurre por:

1. **Reglas de Storage no configuradas** o incorrectas
2. **El path del archivo no coincide** con las reglas de seguridad
3. **Permisos insuficientes** para leer el archivo después de subirlo

## ✅ Solución Paso a Paso

### Paso 1: Verificar y Configurar Reglas de Storage

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Selecciona tu proyecto
3. Ve a **Storage** en el menú lateral
4. Haz clic en la pestaña **"Rules"** (Reglas)
5. **Reemplaza** las reglas actuales con estas:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Permitir lectura/escritura a usuarios autenticados para sus propias licencias
    match /licencias/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // También permitir lectura/escritura en la raíz de licencias (por si acaso)
    match /licencias/{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

6. Haz clic en **"Publish"** (Publicar)

### Paso 2: Verificar que Storage esté Habilitado

1. En Firebase Console, ve a **Storage**
2. Si ves un botón **"Get started"**, haz clic en él
3. Selecciona el modo de seguridad:
   - **"Start in test mode"** para desarrollo (permite todo temporalmente)
   - O **"Start in production mode"** y configura las reglas del Paso 1

### Paso 3: Verificar el Código

El código ya está actualizado para:
- ✅ Usar la estructura de carpetas correcta: `licencias/{userId}/{uuid}.jpg`
- ✅ Limpiar el userId de caracteres problemáticos
- ✅ Obtener la URL correctamente después de subir

### Paso 4: Probar de Nuevo

1. **Compila y ejecuta** la app
2. **Intenta enviar una solicitud** con una imagen
3. **Revisa la consola de Xcode** para ver los logs:
   - `📤 Subiendo imagen a: ...`
   - `✅ Imagen subida exitosamente`
   - `🔗 URL obtenida: ...`

### Paso 5: Verificar en Firebase Console

1. Ve a **Storage** en Firebase Console
2. Deberías ver una carpeta **"licencias"**
3. Dentro debería haber una carpeta con el **userId**
4. Dentro de esa carpeta debería estar el archivo de la imagen

## 🔍 Debugging

Si el error persiste:

### Verificar Logs en Xcode

Revisa la consola de Xcode cuando envíes la solicitud. Deberías ver:
- `📤 Subiendo imagen a: licencias/...`
- `✅ Imagen subida exitosamente`
- `🔗 URL obtenida: ...`

Si ves `❌ Error al subir archivo` o `❌ Error al obtener URL`, el mensaje te dirá qué está fallando.

### Verificar Autenticación

Asegúrate de que el usuario esté autenticado:
- El usuario debe haber iniciado sesión con Google
- `Auth.auth().currentUser` no debe ser `nil`

### Verificar Reglas de Storage

Las reglas deben permitir:
- **Escritura** cuando el usuario sube el archivo
- **Lectura** cuando obtiene la URL

Si las reglas son muy restrictivas, el archivo se sube pero no puedes leerlo después.

## 🚨 Reglas Temporales para Testing

Si necesitas probar rápidamente, puedes usar estas reglas temporales (⚠️ **NO para producción**):

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // ⚠️ SOLO PARA TESTING - Permite todo a usuarios autenticados
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

**Recuerda cambiar estas reglas** antes de ir a producción.

## ✅ Verificación Final

Después de configurar todo, verifica:

1. ✅ Storage está habilitado en Firebase Console
2. ✅ Las reglas están publicadas
3. ✅ El usuario está autenticado en la app
4. ✅ La imagen se sube correctamente (ver en Storage)
5. ✅ La URL se obtiene sin errores

Si todo esto está correcto, el error debería desaparecer.

