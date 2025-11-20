# Configuración de Firebase para Solicitudes

Esta guía te ayudará a configurar Firebase para que las solicitudes se guarden correctamente y recibas notificaciones por correo.

## 1. Configuración de Firebase Storage

### Paso 1: Agregar Firebase Storage al proyecto

1. Abre tu proyecto en Xcode
2. Ve a **File > Add Packages...**
3. Busca `firebase-ios-sdk` y agrega el paquete
4. Asegúrate de que **FirebaseStorage** esté seleccionado en las dependencias

O si usas CocoaPods, agrega a tu `Podfile`:
```ruby
pod 'FirebaseStorage'
```

### Paso 2: Configurar reglas de Storage

En la consola de Firebase, ve a **Storage > Rules** y configura:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Permitir lectura/escritura solo a usuarios autenticados
    match /licencias/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## 2. Configuración de Firestore

### Paso 1: Crear la colección de solicitudes

En la consola de Firebase, ve a **Firestore Database** y crea una colección llamada `solicitudes` con la siguiente estructura:

```
solicitudes/
  {documentId}/
    userId: string
    userEmail: string
    vehiculoNombre: string
    nombreCompleto: string
    telefono: string
    licenciaURL: string
    estado: string (pendiente, en_revision, aprobada, rechazada)
    fechaCreacion: timestamp
    fechaActualizacion: timestamp
```

### Paso 2: Configurar reglas de Firestore

En **Firestore Database > Rules**, configura:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Reglas para solicitudes
    match /solicitudes/{solicitudId} {
      // Los usuarios solo pueden leer sus propias solicitudes
      allow read: if request.auth != null && 
                     (resource.data.userId == request.auth.uid || 
                      request.auth.token.admin == true);
      
      // Los usuarios solo pueden crear solicitudes para sí mismos
      allow create: if request.auth != null && 
                       request.resource.data.userId == request.auth.uid &&
                       request.resource.data.userEmail == request.auth.token.email;
      
      // Solo admins pueden actualizar
      allow update, delete: if request.auth.token.admin == true;
    }
    
    // Reglas para vehículos (lectura pública)
    match /vehiculos/{vehiculoId} {
      allow read: if true;
      allow write: if request.auth.token.admin == true;
    }
  }
}
```

### Paso 3: Crear índices necesarios

En **Firestore Database > Indexes**, crea un índice compuesto:

- Collection: `solicitudes`
- Fields:
  - `userId` (Ascending)
  - `estado` (Ascending)
- Query scope: Collection

## 3. Configuración de Cloud Functions para Envío de Correo

### Paso 1: Instalar Firebase CLI

```bash
npm install -g firebase-tools
firebase login
```

### Paso 2: Inicializar Functions

En la raíz de tu proyecto (o crea una carpeta `functions`):

```bash
firebase init functions
```

Selecciona:
- TypeScript
- ESLint: Yes
- Install dependencies: Yes

### Paso 3: Instalar dependencias necesarias

```bash
cd functions
npm install nodemailer pdfkit @types/nodemailer @types/pdfkit
```

### Paso 4: Crear la función

Crea el archivo `functions/src/index.ts`:

```typescript
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as nodemailer from "nodemailer";
import * as PDFDocument from "pdfkit";
import { Readable } from "stream";

admin.initializeApp();

// Configura tu correo aquí (Gmail, SendGrid, etc.)
const transporter = nodemailer.createTransport({
  service: "gmail", // o "sendgrid", "smtp", etc.
  auth: {
    user: functions.config().email.user, // Tu correo
    pass: functions.config().email.password, // Tu contraseña o app password
  },
});

// Función que se ejecuta cuando se crea una nueva solicitud
export const onSolicitudCreada = functions.firestore
  .document("solicitudes/{solicitudId}")
  .onCreate(async (snap, context) => {
    const solicitud = snap.data();
    const solicitudId = context.params.solicitudId;

    try {
      // Crear PDF
      const pdfBuffer = await crearPDF(solicitud);

      // Enviar correo con PDF adjunto
      await transporter.sendMail({
        from: functions.config().email.user,
        to: "tu-correo@ejemplo.com", // Tu correo donde recibirás las solicitudes
        subject: `Nueva Solicitud: ${solicitud.vehiculoNombre}`,
        html: `
          <h2>Nueva Solicitud de Renta</h2>
          <p><strong>ID:</strong> ${solicitudId}</p>
          <p><strong>Vehículo:</strong> ${solicitud.vehiculoNombre}</p>
          <p><strong>Nombre:</strong> ${solicitud.nombreCompleto}</p>
          <p><strong>Email:</strong> ${solicitud.userEmail}</p>
          <p><strong>Teléfono:</strong> ${solicitud.telefono}</p>
          <p><strong>Estado:</strong> ${solicitud.estado}</p>
          <p><strong>Licencia:</strong> <a href="${solicitud.licenciaURL}">Ver imagen</a></p>
        `,
        attachments: [
          {
            filename: `solicitud_${solicitudId}.pdf`,
            content: pdfBuffer,
          },
        ],
      });

      console.log(`Correo enviado para solicitud ${solicitudId}`);
    } catch (error) {
      console.error("Error al enviar correo:", error);
    }
  });

// Función para crear el PDF
async function crearPDF(solicitud: any): Promise<Buffer> {
  return new Promise((resolve, reject) => {
    const doc = new PDFDocument();
    const buffers: Buffer[] = [];

    doc.on("data", buffers.push.bind(buffers));
    doc.on("end", () => {
      const pdfBuffer = Buffer.concat(buffers);
      resolve(pdfBuffer);
    });
    doc.on("error", reject);

    // Contenido del PDF
    doc.fontSize(20).text("Solicitud de Renta", { align: "center" });
    doc.moveDown();
    doc.fontSize(12);
    doc.text(`Vehículo: ${solicitud.vehiculoNombre}`);
    doc.text(`Nombre: ${solicitud.nombreCompleto}`);
    doc.text(`Email: ${solicitud.userEmail}`);
    doc.text(`Teléfono: ${solicitud.telefono}`);
    doc.text(`Estado: ${solicitud.estado}`);
    doc.text(`Fecha: ${new Date().toLocaleString()}`);
    doc.moveDown();
    doc.text(`Licencia: ${solicitud.licenciaURL}`);

    doc.end();
  });
}
```

### Paso 5: Configurar variables de entorno

```bash
firebase functions:config:set email.user="tu-correo@gmail.com" email.password="tu-app-password"
```

**Nota para Gmail:** Necesitas crear una "App Password" en tu cuenta de Google:
1. Ve a tu cuenta de Google > Seguridad
2. Activa la verificación en 2 pasos
3. Genera una "Contraseña de aplicación"
4. Usa esa contraseña en la configuración

### Paso 6: Desplegar la función

```bash
firebase deploy --only functions
```

## 4. Alternativa: Usar SendGrid (Recomendado para producción)

Si prefieres usar SendGrid (más confiable para producción):

1. Crea una cuenta en SendGrid
2. Obtén tu API Key
3. Instala: `npm install @sendgrid/mail`
4. Actualiza la función:

```typescript
import * as sgMail from "@sendgrid/mail";

sgMail.setApiKey(functions.config().sendgrid.key);

// En lugar de transporter.sendMail, usa:
await sgMail.send({
  to: "tu-correo@ejemplo.com",
  from: "noreply@tudominio.com",
  subject: `Nueva Solicitud: ${solicitud.vehiculoNombre}`,
  html: "...",
  attachments: [
    {
      content: pdfBuffer.toString("base64"),
      filename: `solicitud_${solicitudId}.pdf`,
      type: "application/pdf",
      disposition: "attachment",
    },
  ],
});
```

## 5. Verificación

1. Envía una solicitud desde la app
2. Verifica en Firestore que se creó el documento
3. Verifica en Storage que se subió la imagen
4. Revisa tu correo para confirmar que llegó el PDF
5. Verifica los logs de Cloud Functions en la consola de Firebase

## 6. Reglas de Seguridad Adicionales

Para producción, considera:
- Agregar rate limiting para prevenir spam
- Validar datos antes de guardar
- Implementar verificación de imagen (tamaño, formato)
- Agregar logs de auditoría

## Solución de Problemas

### Error: "Permission denied"
- Verifica las reglas de Firestore y Storage
- Asegúrate de que el usuario esté autenticado

### Error: "Storage not found"
- Verifica que FirebaseStorage esté agregado al proyecto
- Revisa que Firebase esté inicializado correctamente

### El correo no llega
- Verifica los logs de Cloud Functions
- Revisa la configuración del transporter
- Para Gmail, asegúrate de usar App Password, no tu contraseña normal

