//
//  HighScoreView.swift
//  BubblePop
//
//  Created by Jonathon Thomson on 18/4/2025.
//

import SwiftUI

struct HighScoreView: View {
    @StateObject var viewModel: HighScoreViewModel = HighScoreViewModel();
    
    var body: some View {
        HStack {
            Button("Refresh leaderboard") {
                viewModel.refreshLeaderboard();
            }
            .buttonStyle(.borderedProminent)
            Button("Clear leaderboard") {
                viewModel.clearLeaderboard();
            }
            .buttonStyle(.borderedProminent)
        }
        
        Spacer()
        LeaderboardView(leaderboardEntries: viewModel.leaderboard)
        Spacer()
    }
}

#Preview {
    HighScoreView()
}
