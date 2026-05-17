//
//  SpotMeApp.swift
//  SpotMe
//
//  Created by Serhii Roh on 17.05.2026.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

@main
struct SpotMeApp: App {
    @State private var appState = AppState()
    @State private var container = DependencyContainer()

    init() {
        #if DEBUG
        let options = FirebaseOptions(googleAppID: "1:000000000000:ios:0000000000000000", gcmSenderID: "000000000000")
        options.projectID = "demo-spotme"
        options.apiKey = "demo-api-key"
        FirebaseApp.configure(options: options)
        setupEmulators()
        #else
        FirebaseApp.configure()
        #endif
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appState)
                .environment(container)
        }
    }

    #if DEBUG
    private func setupEmulators() {
        let settings = Firestore.firestore().settings
        settings.host = "localhost:8080"
        settings.cacheSettings = MemoryCacheSettings()
        settings.isSSLEnabled = false
        Firestore.firestore().settings = settings
        Auth.auth().useEmulator(withHost: "localhost", port: 9099)
    }
    #endif
}
