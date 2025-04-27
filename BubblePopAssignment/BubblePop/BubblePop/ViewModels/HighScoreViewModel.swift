//
//  HighScoreViewModel.swift
//  BubblePop
//
//  Created by Jonathon Thomson on 27/4/2025.
//

import Foundation

class HighScoreViewModel: ObservableObject {
    @Published var leaderboard: [PlayerLeaderboardEntry] = [];
    
    init() {
        refreshLeaderboard();
    }
    
    func refreshLeaderboard() {
        self.leaderboard = GameHelper.getLeaderboard();
    }
    
    func clearLeaderboard() {
        GameHelper.clearLeaderboard();
        self.leaderboard = [];
    }
}
