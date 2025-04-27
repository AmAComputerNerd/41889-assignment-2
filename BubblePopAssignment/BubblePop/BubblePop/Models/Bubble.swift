//
//  Bubble.swift
//  BubblePop
//
//  Created by Jonathon Thomson on 20/4/2025.
//

import Foundation
import SwiftUICore

struct Bubble: Identifiable, Equatable {    
    let id = UUID();
    var type: BubbleTypeEnum;
    var ability: BubbleAbilityEnum;
    var colour: Color;
    var score: Int;
    var position: CGPoint;
    var velocity: CGPoint;
    
    init(type: BubbleTypeEnum, ability: BubbleAbilityEnum, position: CGPoint, velocity: CGPoint) {
        self.type = type;
        self.ability = ability;
        self.position = position;
        self.velocity = velocity;
        
        switch(type) {
        case .Red: self.colour = .red; self.score = 1;
        case .Pink: self.colour = Color(hex: "e983d8"); self.score = 2;
        case .Green: self.colour = .green; self.score = 5;
        case .Blue: self.colour = .blue; self.score = 8;
        case .Black: self.colour = .black; self.score = 10;
        @unknown default:
            fatalError("Unhandled BubbleTypeEnum case");
        }
    }
}
