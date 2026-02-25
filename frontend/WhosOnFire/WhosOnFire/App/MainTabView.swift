//
//  MainTabView.swift
//  WhosOnFire
//
//  Created by Akhil Madipalli on 2/25/26.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                SearchView()
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
            NavigationStack {
                CompareView()
            }
            .tabItem {
                Label("Compare", systemImage: "person.2")
            }

            NavigationStack {
                UserProfileView()
            }
            .tabItem {
                Label("Profile", systemImage: "person.crop.circle")
            }
        }
    }
}

#Preview {
    MainTabView()
}
