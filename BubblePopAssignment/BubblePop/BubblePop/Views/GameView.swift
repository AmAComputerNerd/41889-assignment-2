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
                    Circle()
                        .fill(bubble.colour)
                        .frame(
                            width: GameHelper.BUBBLE_SIZE,
                            height: GameHelper.BUBBLE_SIZE)
                        .position(
                            x: bubble.position.x,
                            y: bubble.position.y)
                        .onTapGesture {
                            viewModel.popBubble(bubble)
                }
            }
            
            // Game Info (Layer 2)
            VStack {
                Text("Score: \(viewModel.score) | Time left: \(viewModel.timerDuration)")
                
                Spacer()
                
                Text("Player name: \(gameSettings.playerName)")
                Text("Timer: \(gameSettings.gameTimer)")
                Text("Max bubbles: \(gameSettings.maxBubblesOnScreen)")
//                Button(action: {
//                    withAnimation {
//                        viewModel.generateBubbles(gameSettings.maxBubblesOnScreen)
//                    }
//                }) {
//                    Text("Spawn Bubbles")
//                }.buttonStyle(.borderedProminent)
//                Button(action: {
//                    withAnimation(.spring(response: 0.2, dampingFraction: 0.6, blendDuration: 0)) {
//                        viewModel.removeRandomBubbles()
//                    }
//                }) {
//                    Text("Remove Bubbles")
//                }.buttonStyle(.borderedProminent)
                
                Spacer()
            }
            // TODO: Fix warning.
            NavigationLink(
                destination: GameEndView(score: viewModel.score),
                isActive: $viewModel.isGameOver) {
                EmptyView()
            }
            .hidden()
        }
        .onAppear {
            viewModel.startTimers(gameSettings: gameSettings);
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
