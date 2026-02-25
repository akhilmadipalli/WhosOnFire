//
//  PlayerProfileView.swift
//  WhosOnFire
//
//  Created by Akhil Madipalli on 2/25/26.
//

import SwiftUI

struct PlayerProfileView: View {
    var body: some View {
        Text("Player Profile Screen")
            .navigationTitle("Player")
    }
}

#Preview {
    NavigationStack {
        PlayerProfileView()
    }
}
