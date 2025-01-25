//
//  TabBarView.swift
//  SwiftfulFirebaseBootcamp
//
//  Created by Michael on 1/25/25.
//

import SwiftUI

struct TabBarView: View {
    
    @Binding var showSignInView: Bool
    
    var body: some View {
        TabView {
            Tab("Product", systemImage: "cart") {
                NavigationStack {
                    ProductView()
                }
            }
            
            Tab("Favorites", systemImage: "star.fill") {
                NavigationStack {
                    FavoriteView()
                }
            }
            
            Tab("Profile", systemImage: "person") {
                NavigationStack {
                    ProfileView(showSignInView: $showSignInView)
                }
            }
        }
        
    }
}

#Preview {
    TabBarView(showSignInView: .constant(false))
}
