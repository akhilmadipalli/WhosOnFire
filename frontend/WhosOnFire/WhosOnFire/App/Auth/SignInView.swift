//
//  SignInView.swift
//  WhosOnFire
//
//  Created by Akhil Madipalli on 2/25/26.
//

// Sign in a user
import SwiftUI
import Combine

// Observable object keeps track of email, password typed in to update the view
final class SignInEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    

    func signIn(appState: AppState) async throws {
        guard (!email.isEmpty || !password.isEmpty) else {
            print("No email or password found")
            return
        }
        let returnedUserData = try await AuthenticationManager.shared.signInUser(email: email, password: password)
        print("Signed in user: \(returnedUserData)")
        let user = User(id: UUID().uuidString, email: email)
        appState.signIn(user: user)
        
    }
}

// Sign in email
struct SignInView: View {
    @EnvironmentObject var appState: AppState
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
                    print("Signing in user...")
                    try await viewModel.signIn(appState: appState)
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
