//
//  OnFirstAppearViewModifier.swift
//  SwiftfulFirebaseBootcamp
//
//  Created by Michael on 1/28/25.
//

import Foundation
import SwiftUI

struct OnFirstAppearViewModifier: ViewModifier {
    
    @State private var didApear: Bool = false
    let perform: (() -> Void)?
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if !didApear {
                    perform?()
                    didApear = true
                }
            }
    }
}

extension View {
    
    func onFirstApper(perform: (() -> Void)?) -> some View {
        modifier(OnFirstAppearViewModifier(perform: perform))
    }
}
