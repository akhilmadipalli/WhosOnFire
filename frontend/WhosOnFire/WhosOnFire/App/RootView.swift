//
//  RootView.swift
//  WhosOnFire
//
//  Created by Akhil Madipalli on 2/25/26.
//

import SwiftUI
import SwiftData

struct RootView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.modelContext) private var modelContext // Use the environment context

    var body: some View {
        Group {
            if appState.isLoggedIn {
                MainTabView()
            } else {
                AuthenticationView()
            }
        }
        .task {
            let container = modelContext.container
            Task.detached(priority: .high) {
                let backgroundContext = ModelContext(container)
                let seasons = [2021, 2022, 2023, 2024, 2025]
                let positions = ["QB", "RB", "WR", "TE", "FB", "DE", "DT", "CB", "S", "LB", "DB", "DL"]
                
                print("Calling api from RootView...")
                var api = API()
                await api.fetchPlayers(modelContext: backgroundContext)
                await api.fetchPlayerStats(seasons: seasons, modelContext: backgroundContext)
                try backgroundContext.save()
                
                print("Calculating position averages and standard devs...")
                
                let allPlayers = (try? backgroundContext.fetch(FetchDescriptor<Player>())) ?? []
                let allStats = (try? backgroundContext.fetch(FetchDescriptor<PlayerSeasonStat>())) ?? []
                
                var tempAverages: [String: PlayerSeasonStatDTO] = [:]
                var tempStandardDevs: [String: PlayerSeasonStatDTO] = [:]
                let seasonList = seasons.map { String($0) } + ["All"]
                
                for season in seasonList {
                    // use local constant
                    let filteredStats = (season == "All") ? allStats : allStats.filter { String($0.season) == season }
                    
                    for pos in positions {
                        let key = "\(pos)_\(season)"
                        if let avg = await StatEngine.getAverageByPosition(position: pos, allPlayers: allPlayers, allStats: filteredStats) {
                            tempAverages[key] = avg
                        }
                        if let std = await StatEngine.getStdByPosition(position: pos, allPlayers: allPlayers, allStats: filteredStats) {
                            tempStandardDevs[key] = std
                        }
                    }
                }
                let posMeans = tempAverages
                let posStds = tempAverages

                await MainActor.run {
                    appState.positionAverages = posMeans
                    appState.positionStds = posStds
                    print("UI Updated with \(posMeans.count) averages and \(posStds.count) stds.")
                }
            }
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AppState())
    
}
