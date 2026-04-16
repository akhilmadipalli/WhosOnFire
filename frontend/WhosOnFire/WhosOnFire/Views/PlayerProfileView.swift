//
//  PlayerProfileView.swift
//  WhosOnFire
//
//  Created by Akhil Madipalli on 2/25/26.
//

import SwiftUI

struct PlayerProfileView: View {
    let player: Player

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
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
                LazyVGrid(columns: columns, spacing: 12) {
                    StatTileView(title: "Name", value: player.player_display_name)
                    }
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
