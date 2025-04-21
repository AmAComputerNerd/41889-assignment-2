//
//  GameViewModel.swift
//  BubblePop
//
//  Created by Jonathon Thomson on 20/4/2025.
//

import Foundation
import UIKit

class GameViewModel: ObservableObject {
    @Published var score: Int = 0;
    @Published var bubbles: [Bubble] = [];
    @Published var timerDuration: Int = 0;
    @Published var isGameOver: Bool = false;
    private var lastBubbleTypePopped: BubbleTypeEnum?;
    private var gameTimer: Timer?;
    private var bubbleRefreshTimer: Timer?;
    private var bubbleMovementTimer: Timer?;
    
    func startTimers(gameSettings: GameSettingsViewModel) {
        timerDuration = gameSettings.gameTimer;
        // GameTimer - countdown before game ends.
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            // Ensure weak reference to self remains.
            guard let self = self else { return }
            self.timerDuration -= 1;
            if self.timerDuration <= 0 {
                self.endGame();
            }
        }
        
        // BubbleRefreshTimer - removes random bubbles and generates new ones every second.
        bubbleRefreshTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            // Ensure weak reference to self remains.
            guard let self = self else { return }
            if (self.bubbles.count >= Int(Double(gameSettings.maxBubblesOnScreen) * 0.66)) {
                self.removeRandomBubbles();
            }
            self.generateBubbles(gameSettings.maxBubblesOnScreen);
        }
        
        // BubbleMovementTimer - moves bubbles around the screen, adjusting velocity in some cases. EF 1
//        bubbleMovementTimer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { [weak self] _ in
//            // Ensure weak reference to self remains.
//            guard let self = self else { return }
//            self.moveBubblesAndUpdateVelocity();
//        }
    }
    
    func stopTimers() {
        gameTimer?.invalidate();
        bubbleRefreshTimer?.invalidate();
        bubbleMovementTimer?.invalidate();
    }
    
    func clearData() {
        // TODO: Temporary solution to ensure score is cleared when pressing Back on the high score page.
        score = 0;
        bubbles = [];
        isGameOver = false;
        lastBubbleTypePopped = nil;
    }
    
    private func endGame() {
        stopTimers();
        isGameOver = true;
    }
    
    private func moveBubblesAndUpdateVelocity() {
        // Verify bubble will not collide with another bubble or the wall this turn. If so, reverse its velocity to make it "bounce" off this obstacle.
        checkForCollisions();
        
        // Update position based on velocity, with a 10% chance to slightly change the velocity of the bubble.
        for i in 0..<bubbles.count {
            bubbles[i].position = CGPoint(
                x: bubbles[i].position.x + bubbles[i].velocity.x,
                y: bubbles[i].position.y + bubbles[i].velocity.y
            );
            
            let chanceToUpdateVelocity = Int.random(in: 0..<100);
            if (chanceToUpdateVelocity < 10) {
                let velocityXChange = CGFloat.random(in: -0.5...0.5);
                let velocityYChange = CGFloat.random(in: -0.5...0.5);
                bubbles[i].velocity = CGPoint(
                    x: bubbles[i].velocity.x + velocityXChange,
                    y: bubbles[i].velocity.y + velocityYChange
                );
            }
        }
    }
    
    private func checkForCollisions() {
        // Check every bubble's velocity this turn to see if it collides, and reverse it's velocity if it does.
        for i in 0..<bubbles.count {
            let newPosX = bubbles[i].position.x + bubbles[i].velocity.x;
            let newPosY = bubbles[i].position.y + bubbles[i].velocity.y;
            for j in i..<bubbles.count {
                if (doesOverlapBubble(x: newPosX, y: newPosY, bubble: bubbles[j]) ||
                    doesOverlapBoundary(x: newPosX, y: newPosY)) {
                    // Overlap will occur this turn, invert velocity instead.
                    bubbles[i].velocity = CGPoint(
                        x: -bubbles[i].velocity.x,
                        y: -bubbles[i].velocity.y
                    );
                    break;
                }
            }
        }
    }
    
    private func doesCollide(x: Double, y: Double) -> Bool {
        // Checks that no bubble overlaps with this new position we're generating.
        for bubble in bubbles {
            if (doesOverlapBubble(x: x, y: y, bubble: bubble)) {
                return true;
            }
        }
        return false;
    }
    
    private func doesOverlapBubble(x: Double, y: Double, bubble: Bubble) -> Bool {
        let doesOverlapX = (x + GameHelper.BUBBLE_SIZE > bubble.position.x) && (x < bubble.position.x + GameHelper.BUBBLE_SIZE);
        let doesOverlapY = (y + GameHelper.BUBBLE_SIZE > bubble.position.y) && (y < bubble.position.y + GameHelper.BUBBLE_SIZE);
        
        return doesOverlapX || doesOverlapY;
    }
    
    private func doesOverlapBoundary(x: Double, y: Double) -> Bool {
        let screenWidth = UIScreen.main.bounds.width;
        let screenHeight = UIScreen.main.bounds.height;
        let doesOverlapX = (x < GameHelper.BUBBLE_SIZE) || (x + GameHelper.BUBBLE_SIZE > screenWidth);
        let doesOverlapY = (y < GameHelper.BUBBLE_SIZE) || (y + GameHelper.BUBBLE_SIZE > screenHeight);
        
        return doesOverlapX || doesOverlapY;
    }
    
    private func generateBubbles(_ maxNumberOfBubbles: Int) {
        // Verify bubble cap has not been reached.
        let currentNumberOfBubbles = bubbles.count;
        guard (currentNumberOfBubbles < maxNumberOfBubbles) else {
            return;
        }
        
        // Generate a random number of bubbles within the remaining limit or limited by the number of free positions, whichever is least.
        var numberToGenerate = Int.random(in: 0..<(maxNumberOfBubbles - currentNumberOfBubbles));
        // TODO: Consider moving this further up the chain so we don't need to generate every second.
        let screenWidth = UIScreen.main.bounds.width;
        let screenHeight = UIScreen.main.bounds.height;
        let minimumDistance = max(GameHelper.BUBBLE_SIZE, (screenWidth * screenHeight) / CGFloat(maxNumberOfBubbles * 150));
        var poissonDiskPositions = generatePoissonDiskSamples(numberToGenerate, screenWidth, screenHeight, minimumDistance);
        numberToGenerate = min(numberToGenerate, poissonDiskPositions.count);
        
        for _ in 0..<numberToGenerate {
            let randomPosition = poissonDiskPositions.randomElement();
            bubbles.append(generateRandomBubble(position: randomPosition!));
            poissonDiskPositions.removeAll(where: { $0 == randomPosition });
        }
    }
    
    private func generatePoissonDiskSamples(_ numberToGenerate: Int, _ screenWidth: CGFloat, _ screenHeight: CGFloat, _ distance: CGFloat) -> [CGPoint] {
        
        var actualPoints: [CGPoint] = [];
        var activePoints: [CGPoint] = bubbles.map { $0.position };
        
        let seedPoint = CGPoint(x: CGFloat.random(in: 0...screenWidth), y: CGFloat.random(in: 0...screenHeight));
        activePoints.append(seedPoint);
        
        // Check for valid positions to generate bubbles.
        while (!activePoints.isEmpty && actualPoints.count < numberToGenerate) {
            if let activePoint = activePoints.randomElement() {
                var found = false;
                for _ in 0..<15 {
                    let candidate = GameHelper.randomPointAround(activePoint, minimumDistance: distance);
                    
                    if (!actualPoints.contains(where: { GameHelper.distance($0, candidate) < distance }) && !bubbles.contains(where: { GameHelper.distance($0.position, candidate) < distance }) &&
                        GameHelper.isValidPoint(candidate, inScreenWidth: screenWidth, inScreenHeight: screenHeight)) {
                        
                        actualPoints.append(candidate);
                        activePoints.append(candidate);
                        found = true;
                        break;
                    }
                }
                
                if (!found) {
                    activePoints.removeAll(where: { $0 == activePoint });
                }
            }
        }
        
        return actualPoints;
    }
    
    func popBubble(_ bubbleToPop: Bubble) {
        var score = bubbleToPop.score;
        if lastBubbleTypePopped == bubbleToPop.type {
            // Apply score multiplier for one or more bubbles of the same colour popped in a row.
            score *= 2;
        }
        
        self.score += score;
        lastBubbleTypePopped = bubbleToPop.type;
        bubbles.removeAll { $0 == bubbleToPop };
    }
    
    private func removeRandomBubbles() {
        // Remove a random number of bubbles, under the condition the number of bubbles on-screen is more than 3.
        guard (bubbles.count >= 3) else {
            return;
        }
        
        let randomNumber = Int.random(in: 0..<(bubbles.count / 3));
        bubbles.removeFirst(randomNumber);
    }
    
    //
    // TODO: FIX THIS
    //
    private func generateRandomBubble(position: CGPoint) -> Bubble {
        // TODO: Bubbles cannot overlap each other.
        let randomVelocity: CGPoint = CGPoint(
            x: CGFloat.random(in: -3...3),
            y: CGFloat.random(in: -3...3)
        );
        
        let bubbleTypes = [
            (BubbleTypeEnum.Red, 40),
            (BubbleTypeEnum.Pink, 30),
            (BubbleTypeEnum.Green, 15),
            (BubbleTypeEnum.Blue, 10),
            (BubbleTypeEnum.Black, 5)
        ];
        let weightedBubbleTypes = bubbleTypes.flatMap { bubble in Array(repeating: bubble.0, count: bubble.1) };
        let randomBubbleType = weightedBubbleTypes.randomElement() ?? .Red;
        
        let bubble = Bubble(type: randomBubbleType, position: position, velocity: randomVelocity);
        return bubble;
    }
}
