//
//  ContentView.swift
//  BubblePop
//
//  Created by Jonathon Thomson on 8/4/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Label("Bubble Pop", systemImage: "").foregroundStyle(.mint).font(.largeTitle)
                
                Spacer()
                
                StyledNavigationLink(destination: GameSettingsView(), label: "New Game")
                
                StyledNavigationLink(destination: HighScoreView(), label: "High Score")
                
                Button("DEBUG: Clear leaderboard") {
                    GameHelper.clearLeaderboard()
                }
                
                Spacer();
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
