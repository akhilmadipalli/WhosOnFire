//
//  AuthenticationView.swift
//  WhosOnFire2
//
//  Created by lending on 3/16/26.
//

import SwiftUI

struct AuthenticationView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()

                // Branding
                VStack(spacing: 12) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(.orange)
                    Text("Who's On Fire")
                        .font(.largeTitle).bold()
                    Text("Track the hottest players in the NFL")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }

                Spacer()

                // Auth buttons
                VStack(spacing: 12) {
                    NavigationLink(destination: SignInView()) {
                        Text("Sign In")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(Color.blue)
                            .cornerRadius(12)
                            .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
                    }

                    NavigationLink(destination: SignUpView()) {
                        Text("Create Account")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    AuthenticationView()
}
