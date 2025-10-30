//
//  FormularioView.swift
//  AppRentameYA
//

import SwiftUI

struct FormularioView: View {
    @StateObject private var vm: FormularioViewModel
    
    // Inyección del nombre del vehículo
    init(vehiculoNombre: String) {
        _vm = StateObject(wrappedValue: FormularioViewModel(vehiculoNombre: vehiculoNombre))
    }
    
    var body: some View {
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
                    Text("Enviar Aplicación")
                        .fontWeight(.semibold)
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
