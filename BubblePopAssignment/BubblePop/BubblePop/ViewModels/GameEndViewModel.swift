//
//  GameEndViewModel.swift
//  BubblePop
//
//  Created by Jonathon Thomson on 25/4/2025.
//

import Foundation

class GameEndViewModel: ObservableObject {
    @Published var score: Int;
    @Published var isHighScore: Bool;
    @Published var highlightedLeaderboardEntry: PlayerLeaderboardEntry?;
    @Published var leaderboard: [PlayerLeaderboardEntry];
    
    init(_ playerName: String, _ score: Int) {
        self.score = score;
        
        let leaderboard = GameHelper.getLeaderboard();
        self.leaderboard = leaderboard
        
        let leaderboardEntry = leaderboard.first(where: { $0.playerName == playerName });
        self.highlightedLeaderboardEntry = leaderboardEntry;
        
        self.isHighScore = score == leaderboardEntry?.score;
    }
}
