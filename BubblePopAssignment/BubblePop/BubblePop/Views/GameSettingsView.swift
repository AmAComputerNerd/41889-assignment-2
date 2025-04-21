//
//  GameSettingsView.swift
//  BubblePop
//
//  Created by Jonathon Thomson on 18/4/2025.
//

import SwiftUI

struct GameSettingsView: View {
    @EnvironmentObject var viewModel: GameSettingsViewModel
    
    var body: some View {
        VStack {
            Text("Enter your name:");
            TextField("", text: $viewModel.playerName)
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.center)
                .padding()
            
            Text("Timer duration: \(Int(viewModel.gameTimer)) seconds")
            Stepper("", value: $viewModel.gameTimer, in: 30...240)
            
            Text("Max bubble count: \(Int(viewModel.maxBubblesOnScreen)) bubbles")
            Stepper("", value: $viewModel.maxBubblesOnScreen, in: 10...30)
            
            StyledNavigationLink(destination: GameView(), label: "Begin")
        }
        .padding()
    }
}

#Preview {
    GameSettingsView()
        .environmentObject(GameSettingsViewModel())
}
