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
    @State private var showSplash = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if showSplash {
                    SplashScreenView(showSplash: $showSplash)
                        .transition(.opacity)
                } else {
                    if auth.isAuthenticated {
                        RentameYaMainView()
                            .environmentObject(auth)
                            .transition(.opacity)
                    } else {
                        RentameYaWelcomeView()
                            .environmentObject(auth)
                            .transition(.opacity)
                    }
                }
            }
            .animation(.easeInOut(duration: 0.5), value: showSplash)
        }
    }
}
