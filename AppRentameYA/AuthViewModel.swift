//
//  AuthViewModel.swift
//  AppRentameYA
//
//  Created by WIN603 on 14/11/25.
//

import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var user: User? = Auth.auth().currentUser

    static let shared = AuthViewModel()

    private init() {
        // Escuchar cambios de sesión
        Auth.auth().addStateDidChangeListener { _, user in
            self.user = user
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error al cerrar sesión: \(error.localizedDescription)")
        }
    }
}
