//
//  BubbleView.swift
//  BubblePop
//
//  Created by Jonathon Thomson on 21/4/2025.
//

import SwiftUI

struct BubbleView: View {
    @State private var isPopped: Bool = false;
    @State var bubble: Bubble;
    @StateObject var gameViewModel: GameViewModel;
    
    var body: some View {
        Circle()
            .fill(bubble.colour)
            .frame(
                width: GameHelper.BUBBLE_SIZE,
                height: GameHelper.BUBBLE_SIZE)
            .transition(.opacity)
            .scaleEffect(isPopped ? 1.25 : 1)
            .animation(.spring(), value: isPopped)
            .position(
                x: bubble.position.x,
                y: bubble.position.y)
            .onTapGesture {
                withAnimation {
                    isPopped = true;
                    gameViewModel.popBubble(bubble)
                }
            }
    }
}

#Preview {
    BubbleView(bubble: Bubble(type: .Red, position: CGPoint.zero, velocity: CGPoint.zero), gameViewModel: GameViewModel());
}
