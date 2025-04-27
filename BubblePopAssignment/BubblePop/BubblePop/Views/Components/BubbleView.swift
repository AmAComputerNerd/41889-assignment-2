//
//  BubbleView.swift
//  BubblePop
//
//  Created by Jonathon Thomson on 21/4/2025.
//

import SwiftUI

struct BubbleView: View {
    @State private var isPopped: Bool = false;
    @Binding var bubble: Bubble;
    @StateObject var gameViewModel: GameViewModel;
    
    private var bubbleAbilityImageName: String {
        if bubble.ability == .Bomb {
            return "bomb"
        } else if bubble.ability == .Mimic {
            return "mimic"
        } else if bubble.ability == .ScreenClear {
            return "screenclear"
        } else {
            return "";
        }
    }
    
    var body: some View {
        // TODO: Investigate whether it is possible to move position and frame code outside of this component or generally apply it to all elements.
        Circle()
            .fill(
                RadialGradient(
                    gradient: Gradient(colors: [bubble.colour, .white.opacity(0.2)]),
                    center: .center,
                    startRadius: 10,
                    endRadius: GameHelper.BUBBLE_SIZE
                )
            )
            .frame(
                width: GameHelper.BUBBLE_SIZE,
                height: GameHelper.BUBBLE_SIZE
            )
            .transition(.opacity)
            .scaleEffect(isPopped ? 1.25 : 1)
            .animation(.spring(), value: isPopped)
            .position(
                x: bubble.position.x,
                y: bubble.position.y
            )
            .onTapGesture {
                withAnimation {
                    if (!isPopped) {
                        isPopped = true;
                        gameViewModel.popBubble(bubble)
                    }
                }
            }
            .overlay(
                Circle()
                    .stroke( Color.white, lineWidth: 3)
                    .frame(
                        width: GameHelper.BUBBLE_SIZE,
                        height: GameHelper.BUBBLE_SIZE
                    )
                    .blur(radius: 5)
                    .opacity(0.6)
                    .position(
                        x: bubble.position.x,
                        y: bubble.position.y
                    )
            )
            .overlay(
                Circle()
                    .stroke(bubble.colour, lineWidth: 1)
                    .blendMode(.multiply)
                    .frame(
                        width: GameHelper.BUBBLE_SIZE,
                        height: GameHelper.BUBBLE_SIZE
                    )
                    .position(
                        x: bubble.position.x,
                        y: bubble.position.y
                    )
            )
        
        // TODO: This disgusts me.
        let bubbleAbilityOverlay = bubbleAbilityImageName != "" ? AnyView(Image(bubbleAbilityImageName).resizable().scaledToFit().frame(width: 15, height: 15).offset(x: -10, y: -10).position(x: bubble.position.x, y: bubble.position.y)) : AnyView(EmptyView());
        
        ZStack {
            Circle()
                .fill(.white.opacity(0.8))
                .frame(width: 15, height: 15)
                .offset(x: -10, y: -10)
                .position(
                    x: bubble.position.x,
                    y: bubble.position.y
                )
                .overlay {
                    if bubbleAbilityImageName != "" {
                        Image(bubbleAbilityImageName)
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(width: 15, height: 15)
                            .offset(x: -10, y: -10)
                            .position(
                                x: bubble.position.x,
                                y: bubble.position.y
                            )
                    }
                }
        }
    }
}

#Preview {
    BubbleView(bubble: .constant(Bubble(type: .Red, ability: .None, position: CGPoint.zero, velocity: CGPoint.zero)), gameViewModel: GameViewModel());
}
