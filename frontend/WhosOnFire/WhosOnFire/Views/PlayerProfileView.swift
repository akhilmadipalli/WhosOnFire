//
//  PlayerProfileView.swift
//  WhosOnFire
//
//  Created by Akhil Madipalli on 2/25/26.
//

import SwiftData
import SwiftUI
import DDSpiderChart

struct PlayerProfileView: View {
    let player: Player

    @Query var stats: [PlayerSeasonStat]
    @State private var selectedSeason: String = "All"
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var appState: AppState

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var filteredStat: PlayerSeasonStatDTO? {
        StatEngine.aggregate(playerID: player.id, stats: stats, season: selectedSeason)
    }
    var averageStat: PlayerSeasonStatDTO? {
        appState.positionAverages[                "\(player.position)_\(selectedSeason)"]
    }
    var standardDevStat: PlayerSeasonStatDTO? {
        appState.positionStds[                "\(player.position)_\(selectedSeason)"]
    }
    
    init(player: Player) {
        self.player = player
        let targetId = player.id
        let predicate = #Predicate<PlayerSeasonStat> { stat in
            stat.player_id == targetId
        }
        _stats = Query(
            filter: predicate,
            sort: \PlayerSeasonStat.season,
            order: .reverse
        )
        print("Loading player \(player.player_display_name)")
        print(_stats)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Picker("Season", selection: $selectedSeason) {
                    Text("All").tag("All")

                    ForEach(Array(Set(stats.map { $0.season })).sorted(), id: \.self) { year in
                        Text(String(year)).tag(String(year))
                    }
                }.padding()
                VStack(spacing: 8) {

                    // Container
                    AsyncImage(url: URL(string: player.headshot_url)) {
                        image in image.image?.resizable().scaledToFill()
                    }.frame(width: 80, height: 80).clipShape(Circle())

                    Text(player.player_display_name)
                        .font(.largeTitle)
                        .bold()
                    Text("\(player.team) • \(player.position)")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top)

                // Stats grid
                ComparisonModule(statA: filteredStat, statB: averageStat, playerA: player, baseline: averageStat, std: standardDevStat)
                .padding(.horizontal)
            }
        }
        .navigationTitle(player.player_display_name)
        .navigationBarTitleDisplayMode(.inline)
    }
}




#Preview {
    NavigationStack {
        PlayerProfileView(player: MockData.samplePlayers[0])
    }
}

import Foundation

extension Double {
    func to2dp() -> String {
        String(format: "%.2f", self)
    }
}


