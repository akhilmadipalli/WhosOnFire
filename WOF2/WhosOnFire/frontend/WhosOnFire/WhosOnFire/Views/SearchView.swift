//
//  SearchView.swift
//  WhosOnFire
//
//  Created by Akhil Madipalli on 2/25/26.
//

import SwiftData
import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @Query var players: [Player]
    @State private var positionFilter: String? = "All"
    @State private var selectedTeam: String? = "All"
    @State private var favoriteFilter: Bool? = false
    @Environment(\.modelContext) private var modelContext


    let nflTeams = [
        "ARI", "ATL", "BAL", "BUF", "CAR", "CHI", "CIN", "CLE", "DAL", "DEN",
        "DET", "GB", "HOU", "IND", "JAX", "KC", "LAC", "LAR", "LV", "MIA",
        "MIN", "NE", "NO", "NYG", "NYJ", "PHI", "PIT", "SEA", "SF", "TB", "TEN",
        "WAS",
    ]

    var availableTeams: [String]? {
        Array(Set(players.map { $0.team })).sorted()
    }
    var availablePositions: [String]? {
        Array(Set(players.map { $0.position })).sorted()
    }

    var filteredPlayers: [Player] {
        var list = players
        if selectedTeam != "All" {
            list = list.filter { $0.team == selectedTeam }
        }
        if positionFilter != "All" {
            list = list.filter { $0.position == positionFilter }
        }
        if(favoriteFilter == true) {
            list = list.filter {$0.isFavorite == true}
        }
        if !searchText.isEmpty {
                list = list.filter {
                    $0.player_display_name.localizedCaseInsensitiveContains(searchText)
                }
            }

        return list
    }

    var body: some View {
        List(filteredPlayers) { player in
            NavigationLink(destination: PlayerProfileView(player: player)) {
                PlayerRowView(player: player)
            }
        }
        .navigationTitle("Search")
        .searchable(text: $searchText, prompt: "Who's on fire?")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Picker("Team", selection: $selectedTeam) {
                        Text("All Teams").tag("All")
                        ForEach(nflTeams, id: \.self) { team in
                            Text(team).tag(team)
                        }
                    }
                } label: {
                    Label(
                        "Team",
                        systemImage: selectedTeam == "All"
                        ? "football" : "football.fill"
                    )
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Picker("Position", selection: $positionFilter) {
                        Text("All Positions").tag("All")
                        ForEach(availablePositions!, id: \.self) { pos in
                            Text(pos).tag(pos)
                        }
                    }
                } label: {
                    Label(
                        "Position",
                        systemImage: positionFilter == "All"
                        ? "person.circle" : "person.circle.fill"
                    )
                }
                
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    self.favoriteFilter!.toggle()
                }
                label: { Image(systemName: favoriteFilter! ? "star.fill" : "star").foregroundStyle(favoriteFilter! ? .yellow : .gray)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SearchView()
    }
}
