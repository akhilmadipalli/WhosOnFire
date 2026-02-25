//
//  AppState.swift
//  WhosOnFire
//
//  Created by Akhil Madipalli on 2/25/26.
//

import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var currentUser: User? = nil

    func signIn(user: User) {
        currentUser = user
        isLoggedIn = true
    }

    func signOut() {
        currentUser = nil
        isLoggedIn = false
    }
}
