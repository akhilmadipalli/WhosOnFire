//
//  UserProfileView.swift
//  WhosOnFire
//
//  Created by Akhil Madipalli on 2/25/26.
//

import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject var appState: AppState
    @State private var notificationsEnabled = true

    private var initials: String {
        let email = appState.currentUser?.email ?? ""
        return String(email.prefix(1)).uppercased()
    }

    var body: some View {
        List {
            // Avatar + email
            Section {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 60, height: 60)
                        Text(initials)
                            .font(.title2).bold()
                            .foregroundStyle(.blue)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text(appState.currentUser?.email ?? "—")
                            .font(.headline)
                        Text("NFL Fan")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }

            // Favorite players
            Section("Favorite Players") {
                Text("No favorites yet")
                    .foregroundStyle(.secondary)
            }

            // Settings
            Section("Settings") {
                Toggle("Notifications", isOn: $notificationsEnabled)
                NavigationLink("About") {
                    Text("Who's On Fire v1.0")
                        .navigationTitle("About")
                }
            }

            // Appearance
            Section("Appearance") {
                Picker("Theme", selection: $appState.colorSchemePreference) {
                    Text("System").tag("system")
                    Text("Light").tag("light")
                    Text("Dark").tag("dark")
                }
                .pickerStyle(.segmented)
            }

            // Log out
            Section {
                Button("Log Out", role: .destructive) {
                    appState.signOut()
                }
            }
        }
        .navigationTitle("Profile")
    }
}

#Preview {
    NavigationStack {
        UserProfileView()
    }
    .environmentObject(AppState())
}
