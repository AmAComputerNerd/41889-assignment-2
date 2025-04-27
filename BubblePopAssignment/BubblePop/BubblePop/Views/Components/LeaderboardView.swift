//
//  LeaderboardView.swift
//  BubblePop
//
//  Created by Jonathon Thomson on 27/4/2025.
//

import SwiftUI

struct LeaderboardView: View {
    var leaderboardEntries: [PlayerLeaderboardEntry]
    
    var body: some View {
        if !leaderboardEntries.isEmpty {
            List {
                HStack {
                    Text("#")
                        .bold()
                        .frame(width: 30)
                    Text("Player")
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Date")
                        .bold()
                        .frame(width: 100, alignment: .trailing)
                    Text("Score")
                        .bold()
                        .frame(width: 80, alignment: .trailing)
                }
                
                ForEach(leaderboardEntries.indices, id: \.self) { index in
                    let entry = leaderboardEntries[index]
                    HStack {
                        Text("\(index + 1)")
                            .bold()
                            .frame(width: 30)
                        Text(entry.playerName)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(entry.timestamp.formatted(.dateTime.day().month().year()))
                            .frame(width: 100, alignment: .trailing)
                        Text("\(entry.score)")
                            .frame(width: 80, alignment: .trailing)
                    }
                }
            }
        } else {
            Spacer()
            Text("No leaderboard entries yet! :(")
            Spacer()
        }
    }
}

#Preview {
    LeaderboardView(leaderboardEntries: [PlayerLeaderboardEntry(playerName: "Preview", score: 100, timestamp: Date.now)])
}
