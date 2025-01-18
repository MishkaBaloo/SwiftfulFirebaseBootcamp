//
//  SignInGoogleHelper.swift
//  SwiftfulFirebaseBootcamp
//
//  Created by Michael on 1/18/25.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift

struct GoogleSignInResulModel {
    let idToken: String
    let accessToken: String
    let name: String?
    let email: String?
}


final class SignInGoogleHelper {
    
    
    @MainActor func signIn() async throws -> GoogleSignInResulModel {
        guard let topVC = Utilities.shared.topViewController() else {
            throw URLError(.cannotFindHost)
        }
        
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)

        
        guard let idToken: String = gidSignInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        
        let accessToken: String = gidSignInResult.user.accessToken.tokenString
        let name: String = gidSignInResult.user.profile?.name ?? ""
        let email: String = gidSignInResult.user.profile?.email ?? ""

                
        let tokens = GoogleSignInResulModel(idToken: idToken, accessToken: accessToken, name: name, email: email)
        return tokens
    }
}
