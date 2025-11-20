//
//  AgregarVehiculoView.swift
//  AppRentameYA
//

import SwiftUI

struct AgregarVehiculoView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AgregarVehiculoViewModel()
    @ObservedObject var firestoreManager: FirestoreManager
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Título
                    Text("Agregar Nuevo Vehículo")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top, 8)
                    
                    // Nombre del vehículo
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Nombre del vehículo")
                            .font(.headline)
                        TextField("Ej: Nissan Versa", text: $viewModel.nombre)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    // Precio por semana
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Precio por semana (MXN)")
                            .font(.headline)
                        TextField("Ej: 2100", text: $viewModel.precioTexto)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    // Características
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Características")
                            .font(.headline)
                        
                        Text("Agrega una característica a la vez y presiona Enter")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        // Campo para agregar características
                        HStack {
                            TextField("Ej: Automático", text: $viewModel.nuevaCaracteristica)
                                .textFieldStyle(.roundedBorder)
                                .onSubmit {
                                    agregarCaracteristica()
                                }
                            
                            Button(action: agregarCaracteristica) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                            }
                            .disabled(viewModel.nuevaCaracteristica.trimmingCharacters(in: .whitespaces).isEmpty)
                        }
                        
                        // Lista de características agregadas
                        if !viewModel.caracteristicas.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(viewModel.caracteristicas, id: \.self) { caracteristica in
                                    HStack {
                                        Text("• \(caracteristica)")
                                            .font(.subheadline)
                                        Spacer()
                                        Button(action: {
                                            viewModel.caracteristicas.removeAll { $0 == caracteristica }
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.red)
                                        }
                                    }
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 12)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                }
                            }
                            .padding(.top, 8)
                        }
                    }
                    
                    // Mensaje de error
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                    }
                    
                    // Botón de guardar
                    Button(action: {
                        Task {
                            await viewModel.guardarVehiculo(firestoreManager: firestoreManager)
                            if viewModel.vehiculoGuardado {
                                dismiss()
                            }
                        }
                    }) {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            }
                            Text(viewModel.isLoading ? "Guardando..." : "Guardar Vehículo")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(viewModel.puedeGuardar ? Color.blue : Color.gray)
                        .cornerRadius(12)
                    }
                    .disabled(!viewModel.puedeGuardar || viewModel.isLoading)
                    .padding(.top, 8)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func agregarCaracteristica() {
        let caracteristica = viewModel.nuevaCaracteristica.trimmingCharacters(in: .whitespaces)
        if !caracteristica.isEmpty && !viewModel.caracteristicas.contains(caracteristica) {
            viewModel.caracteristicas.append(caracteristica)
            viewModel.nuevaCaracteristica = ""
        }
    }
}

