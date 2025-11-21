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
        .alert(LocalizedKey.error.localized, isPresented: .constant(vm.errorMessage != nil)) {
            Button(LocalizedKey.ok.localized) {
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
                    Text(String(format: LocalizedKey.applyFor.localized, vm.form.vehiculoNombre))
                        .font(.largeTitle).bold()
                        .padding(.top, 8)
                    
                    Text(LocalizedKey.completeData.localized)
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    
                    // Mensaje si ya tiene solicitud para este vehículo
                    if vm.yaTieneSolicitud {
                        InfoBanner(
                            texto: "\(LocalizedKey.alreadyHasApplication.localized) \(LocalizedKey.canApplyOtherVehicles.localized)",
                            color: .orange,
                            mostrarTitulo: false
                        )
                    }
                    
                    // Nombre
                    Group {
                        Text(LocalizedKey.fullName.localized).bold()
                        TextField(LocalizedKey.namePlaceholder.localized, text: $vm.form.nombreCompleto)
                            .textContentType(.name)
                            .submitLabel(.next)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                    
                    // Teléfono
                    Group {
                        Text(LocalizedKey.phoneContact.localized).bold()
                        TextField(LocalizedKey.phonePlaceholder.localized, text: $vm.form.telefono)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        
                        if !vm.telefonoValido && !vm.form.telefono.isEmpty {
                            Text(String(format: LocalizedKey.phoneDigits.localized, vm.form.telefonoSoloDigitos.count))
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding(.top, 4)
                        }
                    }
                    
                    // Archivo licencia
                    Group {
                        Text(LocalizedKey.driverLicense.localized).bold()
                        DashedDropZone(image: $vm.form.licenciaFrente)
                    }
                    
                    // Banner depósito
                    InfoBanner(texto: LocalizedKey.depositBanner.localized)
                    
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
                            
                            Text(LocalizedKey.termsAgreement.localized)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        }
                        
                        if !vm.terminosAceptados && vm.form.nombreCompleto.count > 0 {
                            Text(LocalizedKey.mustAcceptTerms.localized)
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
                        Text(vm.isLoading ? LocalizedKey.sending.localized : LocalizedKey.sendApplication.localized)
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
                    TabBarItemVisual(title: LocalizedKey.inicio.localized, imageName: "house.fill", isSelected: false)
                    Spacer()
                    TabBarItemVisual(title: LocalizedKey.vehiculos.localized, imageName: "car.fill", isSelected: true)
                    Spacer()
                    TabBarItemVisual(title: LocalizedKey.perfil.localized, imageName: "person.fill", isSelected: false)
                    Spacer()
                }
                .padding(.vertical, 8)
                .background(Color.white)
            }
        }
        .navigationTitle(LocalizedKey.vehiculos.localized)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        FormularioView(vehiculoNombre: "Nissan Versa")
    }
}
