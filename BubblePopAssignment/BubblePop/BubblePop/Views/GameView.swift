//
//  GameView.swift
//  BubblePop
//
//  Created by Jonathon Thomson on 18/4/2025.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var gameSettings: GameSettingsViewModel
    @StateObject var viewModel: GameViewModel = GameViewModel();
    
    var body: some View {
        ZStack {
            // Bubbles (Layer 1)
            ForEach($viewModel.bubbles) { $bubble in
                BubbleView(bubble: $bubble, gameViewModel: viewModel)
            }
            
            // Game Info (Layer 2)
            VStack {
                Text("Time left: \(viewModel.timerDuration)")
                Text("Score: \(viewModel.score) | High score to beat: \(viewModel.highestScore)")
                Spacer()
            }
        }
        .onAppear {
            viewModel.startTimers(gameSettings);
        }
        .onDisappear {
            viewModel.stopTimers();
            viewModel.clearData();
        }
        .onChange(of: viewModel.isGameOver) {
            if viewModel.isGameOver {
                navigationManager.navigate(withParams: { AnyView(GameEndView(playerName: gameSettings.playerName, score: viewModel.score)) })
            }
        }
    }
}

#Preview {
    GameView()
        .environmentObject(NavigationManager())
        .environmentObject(GameSettingsViewModel())
}
