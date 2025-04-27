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
        let view = viewModel.currentView
            .environmentObject(gameSettings)
            .environmentObject(viewModel);
        
        if viewModel.supportsNavigation {
            NavigationView() {
                view
            }
        } else {
            view
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(GameSettingsViewModel())
        .environmentObject(NavigationManager())
}
