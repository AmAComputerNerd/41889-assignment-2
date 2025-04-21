//
//  BubblePopApp.swift
//  BubblePop
//
//  Created by Jonathon Thomson on 8/4/2025.
//

import SwiftUI

@main
struct BubblePopApp: App {
    @StateObject private var gameSettings = GameSettingsViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(gameSettings)
        }
    }
}
