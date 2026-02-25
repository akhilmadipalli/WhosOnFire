//
//  UserProfileView.swift
//  WhosOnFire
//
//  Created by Akhil Madipalli on 2/25/26.
//

import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 20) {
            Text("User Profile")
                .font(.title)

            Button("Log Out") {
                appState.signOut()
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .navigationTitle("Profile")
    }
}

#Preview {
    NavigationStack {
        UserProfileView()
    }
    .environmentObject(AppState())
}
