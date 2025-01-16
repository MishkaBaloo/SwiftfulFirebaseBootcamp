//
//  AuthenticationView.swift
//  SwiftfulFirebaseBootcamp
//
//  Created by Michael on 6/23/24.
//

import SwiftUI

struct AuthenticationView: View {
    var body: some View {
        VStack {
            NavigationLink {
                SignInEmailView()
            } label: {
                    Text("Sign In With Email")
                    .font(.headline)
                    .foregroundStyle(Color.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .clipShape(.rect(cornerRadius: 10))
                }
        }
        .padding()
        .navigationTitle("Sing In")
        
        Spacer()
    }
}

#Preview {
    NavigationStack {
        AuthenticationView()
    }
}
