//
//  BubbleAbilityEnum.swift
//  BubblePop
//
//  Created by Jonathon Thomson on 27/4/2025.
//

import Foundation

enum BubbleAbilityEnum {
    // EF 4: Special bubble types
    // None: a normal bubble.
    // Bomb: when popped, pops all other bubbles in a set radius around it.
    // Mimic: changes colours every few seconds, using the percentage table to determine what colour. When popped, grants the number of points determined by it's active colour.
    // ScreenClear: pops all bubbles on the screen when popped.
    case None, Bomb, Mimic, ScreenClear
}
