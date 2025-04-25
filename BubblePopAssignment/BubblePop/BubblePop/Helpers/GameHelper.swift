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
        let radius = BUBBLE_SIZE;
        return point.x >= radius && point.x <= width - radius && point.y >= radius && point.y <= height - radius * 2;
    }
    
    static func distance(_ p1: CGPoint, _ p2: CGPoint) -> CGFloat {
        return hypot(p1.x - p2.x, p1.y - p2.y);
    }
}
