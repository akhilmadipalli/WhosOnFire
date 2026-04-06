//
//  SignInView.swift
//  WhosOnFire
//
//  Created by Akhil Madipalli on 2/25/26.
//

// Sign in a user
import SwiftUI
import Combine

// Observable object keeps track of email, password typed in.
final class SignInEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""

    func signIn() async throws {
        guard (!email.isEmpty || !password.isEmpty) else {
            print("No email or password found")
            return
        }
        
        let returnedUserData = try await AuthenticationManager.shared.createUser(email: email, password: password)
        
    }
}

// Sign in email
struct SignInView: View {
    @StateObject private var viewModel = SignInEmailViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("Sign In")
                .font(.largeTitle)
                .bold()

            TextField("Email", text: $viewModel.email)
                .textFieldStyle(.roundedBorder)

            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(.roundedBorder)

            Button("Sign In") {
                Task {
                    try await viewModel.signIn()
                }
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
