//
//  GameEndViewModel.swift
//  BubblePop
//
//  Created by Jonathon Thomson on 25/4/2025.
//

import Foundation

class GameEndViewModel: ObservableObject {
    @Published var score: Int;
    @Published var highlightedLeaderboardEntry: PlayerLeaderboardEntry?;
    @Published var leaderboard: [PlayerLeaderboardEntry];
    
    init(_ playerName: String, _ score: Int) {
        self.score = score;
        self.leaderboard = GameHelper.getLeaderboard();
        
        let leaderboardEntry = self.leaderboard.first(where: { $0.playerName == playerName });
        self.highlightedLeaderboardEntry = leaderboardEntry;
    }
}
