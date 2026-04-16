//
//  SearchView.swift
//  WhosOnFire
//
//  Created by Akhil Madipalli on 2/25/26.
//

import SwiftUI
import SwiftData

struct SearchView: View {
    @State private var searchText = ""
    @Query var players: [Player]
    
    var body: some View {
        List(players) { player in
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
