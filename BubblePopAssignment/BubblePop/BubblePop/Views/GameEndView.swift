//
//  GameEndView.swift
//  BubblePop
//
//  Created by Jonathon Thomson on 18/4/2025.
//

import SwiftUI

struct GameEndView: View {
    @State var score: Int;
    
    var body: some View {
        Text("Game Over!")
        Text("Your final score was: \r")
    }
}

#Preview {
    GameEndView(score: 0)
}
