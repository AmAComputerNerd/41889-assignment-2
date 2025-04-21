//
//  GameSettingsViewModel.swift
//  BubblePop
//
//  Created by Jonathon Thomson on 18/4/2025.
//

import Foundation

class GameSettingsViewModel: ObservableObject {
    @Published var playerName: String = "Player1";
    @Published var gameTimer: Int = 60;
    @Published var maxBubblesOnScreen: Int = 15;
}
