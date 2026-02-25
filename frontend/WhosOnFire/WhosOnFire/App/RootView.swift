//
//  RootView.swift
//  WhosOnFire
//
//  Created by Akhil Madipalli on 2/25/26.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        Group {
            if appState.isLoggedIn {
                MainTabView()
            } else {
                SignInView()
            }
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AppState())
}
