//
//  AuthenticationViewModel.swift
//  SwiftfulFirebaseBootcamp
//
//  Created by Michael on 1/21/25.
//

import Foundation

@MainActor final class AuthenticationViewModel: ObservableObject {
    
    func signInWithGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        try await UserManager.shared.createNewUser(auth: authDataResult)

    }
    
    func signInWithApple() async throws {
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        let authDataResult = try await AuthenticationManager.shared.signInWithApple(tokens: tokens)
        try await UserManager.shared.createNewUser(auth: authDataResult)

    }
    
    func signInWithAnonymous() async throws {
        let authDataResult = try await AuthenticationManager.shared.signInAnonymous()
        try await UserManager.shared.createNewUser(auth: authDataResult)
    }
}
