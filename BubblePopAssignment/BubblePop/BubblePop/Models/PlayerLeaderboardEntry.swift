//
//  PlayerLeaderboardEntry.swift
//  BubblePop
//
//  Created by Jonathon Thomson on 25/4/2025.
//

import Foundation

// Represents a game result saved into the player leaderboard.
struct PlayerLeaderboardEntry: Identifiable, Codable, Equatable {
    var id = UUID();
    var playerName: String;
    var score: Int;
    var timestamp: Date;
}
