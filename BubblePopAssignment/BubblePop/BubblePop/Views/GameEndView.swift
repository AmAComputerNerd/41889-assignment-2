//
//  GameEndView.swift
//  BubblePop
//
//  Created by Jonathon Thomson on 18/4/2025.
//

import SwiftUI

struct GameEndView: View {
    @StateObject var viewModel: GameEndViewModel;
    
    init(playerName: String, score: Int) {
        self._viewModel = StateObject(wrappedValue: GameEndViewModel(playerName, score));
    }
    
    var body: some View {
        Text("Game Over!")
        Text("Your high score is: \(viewModel.highlightedLeaderboardEntry?.score ?? -1)")
        Text("Your score: \(viewModel.score)")
        Text("There are \(viewModel.leaderboard.count) leaderboard entries.")
    }
}

#Preview {
    GameEndView(playerName: "Preview", score: 69)
}
