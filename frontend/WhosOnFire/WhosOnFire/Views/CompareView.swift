import SwiftData
//
//  CompareView.swift
//  WhosOnFire
//
//  Created by Akhil Madipalli on 2/25/26.
//
import SwiftUI

struct CompareView: View {
    @State private var playerA: Player? = nil
    @State private var playerB: Player? = nil
    @Query(sort: \Player.player_display_name) var allPlayers: [Player]
    @Query var stats: [PlayerSeasonStat]
    @State private var selectedSeason: String = "All"
    @State var playerAStats: PlayerSeasonStatDTO?
    @State var playerBStats: PlayerSeasonStatDTO?
    @EnvironmentObject var appState: AppState

    // Metrics per year-position
    @State var averageStat: PlayerSeasonStatDTO?
    @State var stdStat: PlayerSeasonStatDTO?

    func updatePlayerStats(playerA: Player, playerB: Player) {
        self.playerAStats =
            StatEngine.aggregate(
                playerID: playerA.id,
                stats: stats,
                season: selectedSeason
            )
        self.playerBStats =
            StatEngine.aggregate(
                playerID: playerB.id,
                stats: stats,
                season: selectedSeason
            )
        print(
            "Stats loaded for \(playerA.player_display_name) and \(playerB.player_display_name)"
        )
        self.averageStat =
            appState.positionAverages["\(playerA.position)_\(selectedSeason)"]
        print("Baseline calculated for \(playerA.position)_\(selectedSeason)")
        self.stdStat =
            appState.positionStds["\(playerA.position)_\(selectedSeason)"]
        print(
            "Standard Dev calculated for \(playerA.position)_\(selectedSeason)"
        )

    }

    var body: some View {
        ScrollView {
            Picker("Season", selection: $selectedSeason) {
                Text("All").tag("All")

                ForEach(
                    Array(Set(stats.map { $0.season })).sorted(),
                    id: \.self
                ) { year in
                    Text(String(year)).tag(String(year))
                }
            }.padding()
            VStack(spacing: 24) {
                // Player selectors
                HStack(spacing: 16) {
                    PlayerPicker(
                        label: "Player 1",
                        selected: $playerA,
                        players: allPlayers,
                        positionFilter: nil

                    )
                    PlayerPicker(
                        label: "Player 2",
                        selected: $playerB,
                        players: allPlayers,
                        positionFilter: playerA?.position
                    )
                }
                .padding(.horizontal)

                // Comparison rows
                if playerA != nil && playerB != nil {
                    Text("Two players here")

                    ComparisonModule(
                        statA: playerAStats,
                        statB: playerBStats,
                        playerA: playerA!,
                        baseline: averageStat,
                        std: stdStat
                    )
                    .padding(.horizontal)

                } else {
                    Text("Select two players to compare")
                        .foregroundStyle(.secondary)
                        .padding(.top, 40)
                }
            }
            .padding(.top)
            .onChange(of: playerA) {
                if let a = playerA, let b = playerB {
                    updatePlayerStats(playerA: a, playerB: b)
                }
            }
            .onChange(of: playerB) {
                if let a = playerA, let b = playerB {
                    updatePlayerStats(playerA: a, playerB: b)
                }
            }
            .onChange(of: selectedSeason) {
                if let a = playerA, let b = playerB {
                    updatePlayerStats(playerA: a, playerB: b)
                }
            }
        }
        .navigationTitle("Compare")
    }
}

/// Let's you select from a list of all current players.
struct PlayerPicker: View {
    let label: String
    @Binding var selected: Player?
    let players: [Player]
    var positionFilter: String? = nil

    @State private var isShowingSheet = false
    @State private var searchText = ""

    // Search box
    var filteredPlayers: [Player] {
        var list = players
        if positionFilter != nil {
            list = list.filter { $0.position == positionFilter! }
        }
        if searchText.isEmpty { return list }
        return list.filter {
            $0.player_display_name.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        Button {
            isShowingSheet = true
        } label: {
            VStack(spacing: 6) {
                if let player = selected {
                    AsyncImage(url: URL(string: player.headshot_url)) {
                        image in image.image?.resizable().scaledToFill()
                    }.frame(width: 80, height: 80).clipShape(Circle())
                    Text(player.player_display_name).font(.caption).bold()
                    Text(player.team).font(.caption2).foregroundStyle(
                        .secondary
                    )
                } else {
                    Image(systemName: "plus.circle").font(.title2)
                        .foregroundStyle(.blue)
                    Text(label).font(.caption).foregroundStyle(.blue)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
        }
        .sheet(isPresented: $isShowingSheet) {
            NavigationStack {
                List(filteredPlayers) { player in
                    Button(player.player_display_name) {
                        selected = player
                        isShowingSheet = false
                    }
                    .foregroundStyle(.primary)
                }
                .navigationTitle("Select Player")
                .searchable(text: $searchText, prompt: "Search by name...")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") { isShowingSheet = false }
                    }
                    if selected != nil {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Clear", role: .destructive) {
                                selected = nil
                                isShowingSheet = false
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CompareView()
    }
}
