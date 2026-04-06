//
//  PlayerRowView.swift
//  WhosOnFire
//
//  Created by Akhil Madipalli on 2/25/26.
//

import SwiftUI

struct PlayerRowView: View {
    let player: Player

    var body: some View {
        VStack(alignment: .leading) {
            Text(player.name)
                .font(.headline)
            Text("\(player.team) • \(player.position)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    PlayerRowView(player: MockData.samplePlayers[0])
}
