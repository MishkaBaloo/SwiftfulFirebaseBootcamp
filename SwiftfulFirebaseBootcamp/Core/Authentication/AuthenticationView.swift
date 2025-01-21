//
//  AuthenticationView.swift
//  SwiftfulFirebaseBootcamp
//
//  Created by Michael on 6/23/24.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift



struct AuthenticationView: View {
    
    @StateObject private var viewModel = AuthenticationViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            Button {
                Task {
                    do {
                        try await viewModel.signInWithAnonymous()
                        showSignInView = false
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Sign In Anonymously")
                    .font(.headline)
                    .foregroundStyle(Color.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .clipShape(.rect(cornerRadius: 10))
            }
            
            NavigationLink {
                SignInEmailView(showSignInView: $showSignInView)
            } label: {
                Text("Sign In With Email")
                    .font(.headline)
                    .foregroundStyle(Color.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .clipShape(.rect(cornerRadius: 10))
            }
            
            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)) {
                Task {
                    do {
                        try await viewModel.signInWithGoogle()
                        showSignInView = false
                    } catch {
                        print(error)
                    }
                }
            }
            
            Button {
                Task {
                    do {
                        try await viewModel.signInWithApple()
                        showSignInView = false
                    } catch {
                        print(error)
                    }
                }
            } label: {
                SignInWithAppleButtonViewRepresentable(type: .default, style: .black)
                    .allowsHitTesting(false)
            }
            .frame(height: 55)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Sing In")
    }
}

#Preview {
    NavigationStack {
        AuthenticationView(showSignInView: .constant(false))
    }
}
