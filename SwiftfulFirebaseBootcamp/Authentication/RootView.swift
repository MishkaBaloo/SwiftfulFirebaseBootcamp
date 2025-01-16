//
//  RootView.swift
//  SwiftfulFirebaseBootcamp
//
//  Created by Michael on 6/24/24.
//

import SwiftUI

struct RootView: View {
    
    @State private var showSignInView: Bool = false
    var body: some View {
        ZStack {
            NavigationStack {
                SettingsView(showSignInView: $showSignInView)
            }
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil ? true : false
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView()
            }
        }
    }
}

#Preview {
    RootView()
}
