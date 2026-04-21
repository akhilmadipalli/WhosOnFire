//
//  AuthenticationManager.swift
//  WhosOnFire2\

// Handles Firebase functions to sign up and sign in users.
//
//  Created by Liam Murphy on 3/16/26.


// User is greeted with sign-in email/password, Checks if the entered email/password is in the database.
// Have Create Account, Forgot Password buttons underneath it. Switch to Sign-In View
//

import Foundation
import FirebaseAuth


struct AuthDataResultModel {
    let uuid: String
    let email: String?
}

final class AuthenticationManager {
    static let shared = AuthenticationManager()  // Global
    private init() {
        
    }
    // Registers a user to the firebase auth in console
    // Firebase will hash the password
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password) // Firebase user
        let result = AuthDataResultModel(
            uuid: authDataResult.user.uid,
            email: authDataResult.user.email,
        )
        return result
    }
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel? {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        let result = AuthDataResultModel(
            uuid: authDataResult.user.uid,
            email: authDataResult.user.email,
        )
        return result
        
    }
}


    
    
