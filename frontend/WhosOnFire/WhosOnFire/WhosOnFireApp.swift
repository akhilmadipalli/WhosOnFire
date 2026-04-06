//
//  WhosOnFireApp.swift
//  WhosOnFire
//
//  Created by Akhil Madipalli on 2/25/26.
//

import SwiftUI
import Firebase
import FirebaseCore
import SwiftData

@main
struct WhosOnFireApp: App {
    
    @StateObject private var appState = AppState()
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Player.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    init() {
        FirebaseApp.configure()
        print("Configured firebase settings")
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState).modelContainer(sharedModelContainer)
                .task { // task is an async object
                    print("Calling api")
                    var api = API()
                    await api.fetch()
                }
        }
    }
}
