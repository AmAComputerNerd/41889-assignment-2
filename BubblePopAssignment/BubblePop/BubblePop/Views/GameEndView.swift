//
//  GameEndView.swift
//  BubblePop
//
//  Created by Jonathon Thomson on 18/4/2025.
//

import SwiftUI

struct GameEndView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var gameSettings: GameSettingsViewModel
    @StateObject var viewModel: GameEndViewModel;
    
    init(playerName: String, score: Int) {
        self._viewModel = StateObject(wrappedValue: GameEndViewModel(playerName, score));
    }
    
    var body: some View {
        Text("Game Over!")
            .foregroundStyle(.mint)
            .font(.largeTitle)
        if viewModel.isHighScore {
            Text("New personal high score!")
                .font(.headline)
                .foregroundStyle(.green)
        }
        Text("Your score: \(viewModel.score)")
        Text("Your high score: \(viewModel.highlightedLeaderboardEntry?.score ?? -1)")
        
        LeaderboardView(leaderboardEntries: viewModel.leaderboard)
        
        Button("Continue") {
            gameSettings.resetSettings();
            navigationManager.navigate(to: HomeView.self, supportsNavigation: true)
        }
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    GameEndView(playerName: "Preview", score: 69)
        .environmentObject(NavigationManager())
        .environmentObject(GameSettingsViewModel())
}
