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
                // Header
                VStack(spacing: 8) {
                    Text("🔥")
                        .font(.system(size: 48))
                    Text(player.name)
                        .font(.largeTitle)
                        .bold()
                    Text("\(player.team) • \(player.position)")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top)

                // Stats grid
                LazyVGrid(columns: columns, spacing: 12) {
                    StatTileView(title: "Pass Yds", value: "\(player.passingYards)")
                    StatTileView(title: "TDs", value: "\(player.touchdowns)")
                    StatTileView(title: "Comp %", value: String(format: "%.1f%%", player.completionPct))
                    StatTileView(title: "EPA", value: String(format: "+%.2f", player.epa))
                    StatTileView(title: "QBR", value: String(format: "%.1f", player.qbr!))
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(player.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        PlayerProfileView(player: MockData.samplePlayers[0])
    }
}
