//
//  GameView.swift
//  BubblePop
//
//  Created by Jonathon Thomson on 18/4/2025.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var gameSettings: GameSettingsViewModel
    @StateObject var viewModel: GameViewModel = GameViewModel();
    
    var body: some View {
        ZStack {
            // Bubbles (Layer 1)
            ForEach(viewModel.bubbles) { bubble in
                BubbleView(bubble: bubble, gameViewModel: viewModel)
            }
            
            // Game Info (Layer 2)
            VStack {
                Text("Score: \(viewModel.score) | Time left: \(viewModel.timerDuration)")
                
                Spacer()
                
                Text("Player name: \(gameSettings.playerName)")
                Text("Timer: \(gameSettings.gameTimer)")
                Text("Max bubbles: \(gameSettings.maxBubblesOnScreen)")
                
                Spacer()
            }
            // TODO: Fix warning.
            NavigationLink(
                destination: GameEndView(playerName: gameSettings.playerName, score: viewModel.score),
                isActive: $viewModel.isGameOver
            ) {
                EmptyView()
            }
            .hidden()
        }
        .onAppear {
            viewModel.startTimers(gameSettings);
        }
        .onDisappear {
            viewModel.stopTimers();
            viewModel.clearData();
        }
    }
}

#Preview {
    GameView()
        .environmentObject(GameSettingsViewModel())
}
