//
//  HomeView.swift
//  BubblePop
//
//  Created by Jonathon Thomson on 27/4/2025.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Label("Bubble Pop", systemImage: "").foregroundStyle(.mint).font(.largeTitle)
            
            Spacer()
            
            StyledNavigationLink(destination: GameSettingsView(), label: "New Game")
            
            StyledNavigationLink(destination: HighScoreView(), label: "High Score")
            
            Spacer();
        }
        .padding()
    }
}

#Preview {
    HomeView()
}
