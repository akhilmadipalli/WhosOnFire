//
//  StatTileView.swift
//  WhosOnFire
//
//  Created by Akhil Madipalli on 2/25/26.
//


import SwiftUI

struct StatTileView: View {
    let title: String
    let value: String

    var body: some View {
        VStack {
            Text(value)
                .font(.title2)
                .bold()
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview {
    StatTileView(title: "EPA", value: "+0.25")
}