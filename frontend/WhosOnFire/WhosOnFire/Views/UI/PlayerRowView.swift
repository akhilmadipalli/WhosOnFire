//
//  PlayerRowView.swift
//  WhosOnFire
//
//  Created by Akhil Madipalli on 2/25/26.
//

import SwiftUI
import SwiftData

struct PlayerRowView: View {
    let player: Player
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                AsyncImage(url: URL(string: player.headshot_url)) {
                    image in image.image?.resizable().scaledToFill()
                }.frame(width: 40, height: 40).clipShape(Circle())
                
                Text(player.player_display_name)
                    .font(.headline)
            }
            Text("\(player.team) • \(player.position)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
}
