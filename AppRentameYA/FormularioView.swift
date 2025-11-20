//
//  FormularioView.swift
//  AppRentameYA
//

import SwiftUI

struct FormularioView: View {
    @StateObject private var vm: FormularioViewModel
    @Environment(\.dismiss) private var dismiss
    
    // Inyección del nombre del vehículo
    init(vehiculoNombre: String) {
        _vm = StateObject(wrappedValue: FormularioViewModel(vehiculoNombre: vehiculoNombre))
    }
    
    var body: some View {
        Group {
            if vm.solicitudEnviada {
                SolicitudEnviadaViewVisual()
            } else {
                formularioContent
            }
        }
        .alert("Error", isPresented: .constant(vm.errorMessage != nil)) {
            Button("OK") {
                vm.errorMessage = nil
            }
        } message: {
            if let error = vm.errorMessage {
                Text(error)
            }
        }
    }
    
    private var formularioContent: some View {
        VStack(spacing: 0) {
            // Encabezado con back automático si lo presentas dentro de NavigationStack
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Título
                    Text("Aplicar para \(vm.form.vehiculoNombre)")
                        .font(.largeTitle).bold()
                        .padding(.top, 8)
                    
                    Text("Completa tus datos. Un asesor te contactará a la brevedad.")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    
                    // Mensaje si ya tiene solicitud
                    if vm.yaTieneSolicitud {
                        InfoBanner(
                            texto: "Ya tienes una solicitud pendiente. No puedes enviar otra hasta que se procese la actual.",
                            color: .orange,
                            mostrarTitulo: false
                        )
                    }
                    
                    // Nombre
                    Group {
                        Text("Nombre completo").bold()
                        TextField("Tu nombre y apellido", text: $vm.form.nombreCompleto)
                            .textContentType(.name)
                            .submitLabel(.next)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                    
                    // Teléfono
                    Group {
                        Text("Teléfono de contacto").bold()
                        TextField("10 dígitos", text: $vm.form.telefono)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                    
                    // Archivo licencia
                    Group {
                        Text("Licencia de conducir (frente)").bold()
                        DashedDropZone(image: $vm.form.licenciaFrente)
                    }
                    
                    // Banner depósito
                    InfoBanner(texto: "Se requiere un depósito de $3,500 MXN al firmar el contrato.")
                    
                    // Checkbox de consentimiento
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .top, spacing: 12) {
                            Button(action: {
                                vm.form.aceptaTerminos.toggle()
                            }) {
                                Image(systemName: vm.form.aceptaTerminos ? "checkmark.square.fill" : "square")
                                    .foregroundColor(vm.form.aceptaTerminos ? .blue : .gray)
                                    .font(.title3)
                            }
                            
                            Text("Estoy de acuerdo en que mis datos personales (nombre, teléfono e imagen de licencia) sean utilizados para el proceso de evaluación de mi solicitud de renta de vehículo y para contactarme respecto a esta solicitud.")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        }
                        
                        if !vm.terminosAceptados && vm.form.nombreCompleto.count > 0 {
                            Text("Debes aceptar los términos para continuar")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Espacio para que el botón no quede pegado al TabBar
                    Spacer(minLength: 8)
                }
                .padding(.horizontal)
                .padding(.bottom, 12)
            }
            .background(Color(.systemGroupedBackground))
            
            // Botón enviar
            VStack(spacing: 8) {
                Button(action: vm.enviar) {
                    HStack {
                        if vm.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        }
                        Text(vm.isLoading ? "Enviando..." : "Enviar Aplicación")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(vm.puedeEnviar ? Color.blue : Color.gray)
                    .cornerRadius(12)
                }
                .disabled(!vm.puedeEnviar)
                .padding(.horizontal)
                
                // Tu TabBar
                Divider()
                HStack {
                    Spacer()
                    TabBarItemVisual(title: "Inicio", imageName: "house.fill", isSelected: false)
                    Spacer()
                    TabBarItemVisual(title: "Vehículos", imageName: "car.fill", isSelected: true)
                    Spacer()
                    TabBarItemVisual(title: "Perfil", imageName: "person.fill", isSelected: false)
                    Spacer()
                }
                .padding(.vertical, 8)
                .background(Color.white)
            }
        }
        .navigationTitle("Vehículos")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        FormularioView(vehiculoNombre: "Nissan Versa")
    }
}
