//
//  ContentView.swift
//  BubblePop
//
//  Created by Jonathon Thomson on 8/4/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        // TODO: NavigationController view.
        NavigationStack {
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
}

#Preview {
    ContentView()
}
