//
//  BubblePopApp.swift
//  BubblePop
//
//  Created by Jonathon Thomson on 8/4/2025.
//

import SwiftUI

@main
struct BubblePopApp: App {
    @StateObject private var navigationManager: NavigationManager = NavigationManager();
    @StateObject private var gameSettings: GameSettingsViewModel = GameSettingsViewModel();
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(navigationManager)
                .environmentObject(gameSettings)
        }
    }
}
