//
//  ContentView.swift
//  BubblePop
//
//  Created by Jonathon Thomson on 8/4/2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var gameSettings: GameSettingsViewModel;
    @EnvironmentObject private var viewModel: NavigationManager;
    
    var body: some View {
        viewModel.currentView
            .environmentObject(gameSettings)
            .environmentObject(viewModel)
    }
}

#Preview {
    ContentView()
        .environmentObject(GameSettingsViewModel())
        .environmentObject(NavigationManager())
}
