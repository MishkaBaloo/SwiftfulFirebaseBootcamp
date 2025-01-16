//
//  SignInEmailView.swift
//  SwiftfulFirebaseBootcamp
//
//  Created by Michael on 6/24/24.
//

import SwiftUI

@MainActor final class SignInEmailViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    
    func signIn() {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
        
        Task {
            do {
                let returnedUserData = try await AuthenticationManager.shared.createUser(email: email, password: password)
                print("Success")
                print(returnedUserData)
            } catch {
                print("Error")
                print("Error: \(error)")
            }
        }
    }
}

struct SignInEmailView: View {
    
    @StateObject private var viewModel = SignInEmailViewModel()
    
    var body: some View {
        VStack {
            TextField("Email...", text: $viewModel.email)
                .padding()
                .background(Color.gray.opacity(0.4))
                .clipShape(.rect(cornerRadius: 10))
            
            SecureField("Password...", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.4))
                .clipShape(.rect(cornerRadius: 10))
            
            Button(action: {
                viewModel.signIn()
            }, label: {
                Text("Sign In")
                .font(.headline)
                .foregroundStyle(Color.white)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .clipShape(.rect(cornerRadius: 10))
            })
            
            Spacer()
            
        }
        .padding()
        .navigationTitle("Sign In With Email")
    }
}

#Preview {
    NavigationStack {
        SignInEmailView()
    }
}
