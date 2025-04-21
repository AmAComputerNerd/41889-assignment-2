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
                
//                NavigationLink(destination: GameSettingsView()) {
//                    
//                    Button("New Game") {}
//                        .buttonStyle(.borderedProminent)
//                    
//                }
                
                StyledNavigationLink(destination: GameSettingsView(), label: "New Game")
                
//                NavigationLink(destination: HighScoreView()) {
//                    
//                    Button("High Score") {}
//                        .buttonStyle(.borderedProminent)
//                    
//                }
                
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
