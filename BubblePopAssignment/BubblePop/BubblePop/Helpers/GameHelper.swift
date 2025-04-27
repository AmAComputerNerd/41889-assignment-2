//
//  GameHelper.swift
//  BubblePop
//
//  Created by Jonathon Thomson on 21/4/2025.
//

import Foundation

class GameHelper {
    // Static variables
    static let BUBBLE_SIZE: CGFloat = 70;
    
    // Poisson Disk Sampling functions
    static func randomPointAround(_ point: CGPoint, minimumDistance: CGFloat) -> CGPoint {
        let radius = CGFloat.random(in: minimumDistance...(3 * minimumDistance));
        let angle = CGFloat.random(in: 0...(2 * .pi));
        return CGPoint(
            x: point.x + radius * cos(angle),
            y: point.y + radius * sin(angle)
        );
    }
    
    static func isValidPoint(_ point: CGPoint, inScreenWidth width: CGFloat, inScreenHeight height: CGFloat) -> Bool {
        // Apply additional padding to the top and bottom of the screen to account for safe area and the score / timer text.
        let radius = BUBBLE_SIZE / 2;
        return point.x >= radius && point.x <= width - radius && point.y >= BUBBLE_SIZE && point.y <= height - (BUBBLE_SIZE * 2);
    }
    
    static func distance(_ p1: CGPoint, _ p2: CGPoint) -> CGFloat {
        return hypot(p1.x - p2.x, p1.y - p2.y);
    }
    
    // Leaderboard functions
    static func getLeaderboard() -> [PlayerLeaderboardEntry] {
        if let savedData = UserDefaults.standard.data(forKey: "leaderboard") {
            if let decodedData = try? JSONDecoder().decode([PlayerLeaderboardEntry].self, from: savedData) {
                return decodedData.sorted(by: { $0.score > $1.score });
            }
        }
        return [];
    }
    
    static func updatePlayerLeaderboardEntry(playerName: String, score: Int) -> PlayerLeaderboardEntry? {
        var leaderboard = getLeaderboard();
        if let existingRecord = leaderboard.first(where: { $0.playerName == playerName }) {
            // If there is already a record, we should only update the record if the newest score is higher.
            if score <= existingRecord.score {
                return nil;
            }
            leaderboard.remove(at: leaderboard.firstIndex(of: existingRecord)!);
        }
        
        let now = Date.now;
        let entry = PlayerLeaderboardEntry(playerName: playerName, score: score, timestamp: now);
        leaderboard.append(entry);
        
        if let encodedData = try? JSONEncoder().encode(leaderboard) {
            UserDefaults.standard.set(encodedData, forKey: "leaderboard");
            return entry;
        }
        return nil;
    }
    
    static func clearLeaderboard() {
        UserDefaults.standard.removeObject(forKey: "leaderboard");
    }
}
