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
    
    // Setup SwiftData
    var sharedModelContainer: ModelContainer = {
        // Define model schema
        let schema = Schema([
            Player.self,
            PlayerSeasonStat.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    // Setup Firebase
    init() {
        FirebaseApp.configure()
        print("Configured firebase settings")
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState).modelContainer(sharedModelContainer)
                .task { // task is an async object
                    let modelContext = sharedModelContainer.mainContext
                    let seasons = [2023, 2024, 2025]
                    print("Calling api")
                    var api = API()
                    await api.fetchPlayers(modelContext: modelContext) // Load players
                    //await api.fetchPlayerStats(seasons: seasons, modelContext: modelContext)
                }
        }
    }
}
