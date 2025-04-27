//
//  GameEndView.swift
//  BubblePop
//
//  Created by Jonathon Thomson on 18/4/2025.
//

import SwiftUI

struct GameEndView: View {
    @StateObject var viewModel: GameEndViewModel;
    
    init(playerName: String, score: Int) {
        self._viewModel = StateObject(wrappedValue: GameEndViewModel(playerName, score));
    }
    
    var body: some View {
        Text("Game Over!")
        if viewModel.isHighScore {
            Text("New high score!")
                .font(.headline)
                .foregroundStyle(.green)
        }
        Text("Your score: \(viewModel.score)")
        Text("Your high score: \(viewModel.highlightedLeaderboardEntry?.score ?? -1)")
        
        LeaderboardView(leaderboardEntries: viewModel.leaderboard)
        
        StyledNavigationLink(destination: ContentView(), label: "Continue")
    }
}

#Preview {
    GameEndView(playerName: "Preview", score: 69)
}
