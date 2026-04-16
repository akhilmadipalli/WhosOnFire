//
//  SignUpView.swift
//  WhosOnFire
//
//  Created by Akhil Madipalli on 2/25/26.
//

// Create a user

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var appState: AppState
//    @StateObject private var viewModel = SignUpEmailViewModel()
    @State private var email = ""
    @State private var password = ""
    
    
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Sign Up")
                .font(.largeTitle)
                .bold()

            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)

            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)

            Button("Sign Up") {
                let user = User(id: UUID().uuidString, email: email)
                appState.signIn(user: user)
                
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    SignUpView()
        .environmentObject(AppState())
}
