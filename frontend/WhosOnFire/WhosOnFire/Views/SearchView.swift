//
//  SearchView.swift
//  WhosOnFire
//
//  Created by Akhil Madipalli on 2/25/26.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""

    var filteredPlayers: [Player] {
        if searchText.isEmpty {
            return MockData.samplePlayers
        }
        return MockData.samplePlayers.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        List(filteredPlayers) { player in
            NavigationLink(destination: PlayerProfileView(player: player)) {
                PlayerRowView(player: player)
            }
        }
        .searchable(text: $searchText, prompt: "Search players")
        .navigationTitle("Search")
    }
}

#Preview {
    NavigationStack {
        SearchView()
    }
}
