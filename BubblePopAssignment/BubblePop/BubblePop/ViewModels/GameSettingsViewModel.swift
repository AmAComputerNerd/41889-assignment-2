//
//  GameSettingsViewModel.swift
//  BubblePop
//
//  Created by Jonathon Thomson on 18/4/2025.
//

import Foundation

class GameSettingsViewModel: ObservableObject {
    @Published var playerName: String = "Player1";
    @Published var gameTimerInternal: Double = 60;
    @Published var maxBubblesOnScreenInternal: Double = 15;
    
    var gameTimer: Int {
        Int(gameTimerInternal)
    }
    var maxBubblesOnScreen: Int {
        Int(maxBubblesOnScreenInternal)
    }
    
    func resetSettings() {
        playerName = "Player1";
        gameTimerInternal = 60;
        maxBubblesOnScreenInternal = 15;
    }
}
