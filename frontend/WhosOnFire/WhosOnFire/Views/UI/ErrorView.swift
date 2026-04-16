//
//  ErrorView.swift
//  WhosOnFire
//
//  Created by Akhil Madipalli on 2/25/26.
//


import SwiftUI

struct ErrorView: View {
    let message: String

    var body: some View {
        Text(message)
            .foregroundColor(.red)
    }
}

#Preview {
    ErrorView(message: "Something went wrong")
}