//
//  GameSettingsView.swift
//  BubblePop
//
//  Created by Jonathon Thomson on 18/4/2025.
//

import SwiftUI

struct GameSettingsView: View {
    @EnvironmentObject var navigationManager: NavigationManager;
    @EnvironmentObject var viewModel: GameSettingsViewModel;
    
    var body: some View {
        VStack {
            Text("Game Settings")
                .foregroundStyle(.mint)
                .font(.largeTitle)
            Spacer()
            Text("Enter your name:");
            TextField("", text: $viewModel.playerName)
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.center)
                .padding()
            
            Text("Timer duration: \(viewModel.gameTimer) seconds")
            Slider(value: $viewModel.gameTimerInternal, in: 30...120)
            
            Text("Max bubble count: \(viewModel.maxBubblesOnScreen) bubbles")
            Slider(value: $viewModel.maxBubblesOnScreenInternal, in: 10...30)
            
            Button("Begin") {
                navigationManager.navigate(to: GameView.self);
            }
            .buttonStyle(.borderedProminent)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    GameSettingsView()
        .environmentObject(GameSettingsViewModel())
        .environmentObject(NavigationManager())
}
