//
//  SignInView.swift
//  WhosOnFire
//
//  Created by Akhil Madipalli on 2/25/26.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var appState: AppState
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Sign In")
                .font(.largeTitle)
                .bold()

            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)

            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)

            Button("Sign In") {
                let user = User(id: UUID().uuidString, email: email)
                appState.signIn(user: user)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    SignInView()
        .environmentObject(AppState())
}
