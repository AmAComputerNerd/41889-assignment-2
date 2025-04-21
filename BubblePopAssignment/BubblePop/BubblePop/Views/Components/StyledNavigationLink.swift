//
//  StyledNavigationLink.swift
//  BubblePop
//
//  Created by Jonathon Thomson on 18/4/2025.
//

import SwiftUI

struct StyledNavigationLink<Destination: View>: View {
    let destination: Destination
    let label: String
    
    var body: some View {
        NavigationLink(destination: destination) {
            Text(label)
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .foregroundColor(.white)
                .background(.blue)
                .cornerRadius(6);
        }
    }
}

#Preview {
    StyledNavigationLink<ContentView>(destination: ContentView(), label: "Preview")
}
