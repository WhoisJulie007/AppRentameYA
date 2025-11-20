//
//  AppRentameYAApp.swift
//  AppRentameYA
//
//  Created by Maydeli Castan on 29/10/25.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseAppCheck

@main
struct AppRentameYAApp: App {
    
    // Se ejecuta al iniciar la app
    init() {
        FirebaseApp.configure()
        
        #if DEBUG
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        #endif
    }

    @StateObject private var auth = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            if auth.isAuthenticated {
                RentameYaMainView()
                    .environmentObject(auth)
            } else {
                RentameYaWelcomeView()
                    .environmentObject(auth)
            }
        }
    }
}
