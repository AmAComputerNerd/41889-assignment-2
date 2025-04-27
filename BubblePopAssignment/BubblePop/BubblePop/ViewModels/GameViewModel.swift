//
//  GameViewModel.swift
//  BubblePop
//
//  Created by Jonathon Thomson on 20/4/2025.
//

import Foundation
import UIKit
import SwiftUI

class GameViewModel: ObservableObject {
    @Published var highestScore: Int = 0;
    @Published var score: Int = 0;
    @Published var bubbles: [Bubble] = [];
    @Published var timerDuration: Int = 0;
    @Published var isGameOver: Bool = false;
    private var lastBubbleTypePopped: BubbleTypeEnum?;
    private var gameTimer: Timer?;
    private var bubbleRefreshTimer: Timer?;
    private var bubbleMovementTimer: Timer?;
    private var bubbleMimicColourChangeTimer: Timer?
    
    func startTimers(_ gameSettings: GameSettingsViewModel) {
        let leaderboard = GameHelper.getLeaderboard();
        if (leaderboard.count > 0) {
            // Leaderboard is sorted by score, descending, so the first element is always the high score.
            highestScore = leaderboard[0].score;
        }
        timerDuration = gameSettings.gameTimer;
        
        // GameTimer - countdown before game ends.
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            // Ensure weak reference to self remains.
            guard let self = self else { return }
            self.timerDuration -= 1;
            if self.timerDuration <= 0 {
                self.endGame(gameSettings.playerName);
            }
        }
        
        // BubbleRefreshTimer - removes random bubbles and generates new ones every second.
        bubbleRefreshTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            // Ensure weak reference to self remains.
            guard let self = self else { return }
            if (self.bubbles.count >= Int(Double(gameSettings.maxBubblesOnScreen) * 0.33)) {
                self.removeRandomBubbles();
            }
            self.generateBubbles(gameSettings.maxBubblesOnScreen);
        }
        
        // BubbleMovementTimer - moves bubbles around the screen, adjusting velocity in some cases. EF 1
        bubbleMovementTimer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { [weak self] _ in
            // Ensure weak reference to self remains.
            guard let self = self else { return };
            withAnimation {
                self.moveBubblesAndUpdateVelocity(gameSettings.gameTimer);
            }
        }
        
        // BubbleMimicColourChangeTimer - changes the colour of mimic bubbles.
        bubbleMimicColourChangeTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            // Ensure weak reference to self remains.
            guard let self = self else { return };
            
            let mimicBubbles = self.bubbles.filter { $0.ability == BubbleAbilityEnum.Mimic };
            mimicBubbles.forEach { self.applyBubbleAbility($0) }
        }
    }
    
    func stopTimers() {
        gameTimer?.invalidate();
        bubbleRefreshTimer?.invalidate();
        bubbleMovementTimer?.invalidate();
        bubbleMimicColourChangeTimer?.invalidate();
    }
    
    func clearData() {
        score = 0;
        bubbles = [];
        isGameOver = false;
        lastBubbleTypePopped = nil;
    }
    
    func popBubble(_ bubbleToPop: Bubble, isBeingPoppedByAbility: Bool = false) {
        if !isBeingPoppedByAbility && bubbleToPop.ability != BubbleAbilityEnum.Mimic { // Mimic handled elsewhere
            // Don't apply abilities for bubbles which were popped by another ability.
            applyBubbleAbility(bubbleToPop);
        }
        
        var score = Double(bubbleToPop.score);
        if lastBubbleTypePopped == bubbleToPop.type {
            // Apply score multiplier for one or more bubbles of the same colour popped in a row.
            score *= 1.5;
        }
        
        self.score += Int(score);
        lastBubbleTypePopped = bubbleToPop.type;
        bubbles.removeAll { $0.id == bubbleToPop.id };
    }
    
    private func applyBubbleAbility(_ bubble: Bubble) {
        let ability = bubble.ability;
        if ability == BubbleAbilityEnum.Bomb {
            // Bomb: Pop all bubbles in a radius of BUBBLE_SIZE * 1.5 around this bubble.
            let explosionRadius: CGFloat = GameHelper.BUBBLE_SIZE * 1.5;
            let bubblesInRange = bubbles.filter {
                $0.id != bubble.id &&
                GameHelper.distance(bubble.position, $0.position) < explosionRadius
            };
            bubblesInRange.forEach { popBubble($0, isBeingPoppedByAbility: true) };
        } else if ability == BubbleAbilityEnum.Mimic {
            // Mimic: Changes colour every 0.5s.
            let indexOfBubble = bubbles.firstIndex(of: bubble)!;
            let tempBubble = generateRandomBubble(position: CGPoint.zero);
            bubbles[indexOfBubble].type = tempBubble.type;
            bubbles[indexOfBubble].colour = tempBubble.colour;
            bubbles[indexOfBubble].score = tempBubble.score;
        } else if ability == BubbleAbilityEnum.ScreenClear {
            // Screen clear: Pops all bubbles on the screen.
            let copyOfBubbles = bubbles;
            copyOfBubbles.forEach { popBubble($0, isBeingPoppedByAbility: true) };
        }
    }
    
    private func endGame(_ playerName: String) {
        stopTimers();
        _ = GameHelper.updatePlayerLeaderboardEntry(playerName: playerName, score: self.score)
        isGameOver = true;
    }
    
    private func moveBubblesAndUpdateVelocity(_ totalTimerLength: Int) {
        for i in 0..<bubbles.count {
            // Calculate true velocity
            let bubble = bubbles[i];
            let timeRatio = 1 + ((CGFloat(totalTimerLength) - CGFloat(timerDuration)) / CGFloat(totalTimerLength));
            let trueVelocity = CGPoint(
                x: bubble.velocity.x * timeRatio,
                y: bubble.velocity.y * timeRatio
            );
            
            // Update position / reverse velocity if new position would result in overlap.
            if (!checkBubbleOverlap(bubble, trueVelocity)) {
                bubbles[i].position = CGPoint(
                    x: bubble.position.x + trueVelocity.x,
                    y: bubble.position.y + trueVelocity.y
                );
            } else {
                bubbles[i].velocity = CGPoint(
                    x: -bubble.velocity.x,
                    y: -bubble.velocity.y
                );
            }
            
            // Roll chance to update velocity.
            let chanceToUpdateVelocity = Int.random(in: 0..<100);
            if chanceToUpdateVelocity < 10 {
                let velocityXChange = CGFloat.random(in: -0.5...0.5);
                let velocityYChange = CGFloat.random(in: -0.5...0.5);
                bubbles[i].velocity = CGPoint(
                    x: bubbles[i].velocity.x + velocityXChange,
                    y: bubbles[i].velocity.y + velocityYChange
                );
            }
        }
        
        // Remove all bubbles that are out of bounds.
        bubbles.removeAll(where: { checkBubbleOutOfBounds($0) })
    }
    
    private func checkBubbleOverlap(_ bubble: Bubble, _ velocity: CGPoint) -> Bool {
        let newBubblePosition = CGPoint(
            x: bubble.position.x + velocity.x,
            y: bubble.position.y + velocity.y
        );
        
        let bubblesWithinRange = bubbles.filter({ $0.id != bubble.id && GameHelper.distance(newBubblePosition, $0.position) < GameHelper.BUBBLE_SIZE });
        return !bubblesWithinRange.isEmpty;
    }
    
    private func checkBubbleOutOfBounds(_ bubble: Bubble) -> Bool {
        let bubbleRadius = GameHelper.BUBBLE_SIZE / 2;
        let screenWidth = UIScreen.main.bounds.width;
        let screenHeight = UIScreen.main.bounds.height;
        
        return bubble.position.x + bubbleRadius < 0 ||
                bubble.position.x - bubbleRadius > screenWidth ||
                bubble.position.y + bubbleRadius < 0 ||
                bubble.position.y - bubbleRadius > screenHeight;
    }
    
    private func generateBubbles(_ maxNumberOfBubbles: Int) {
        // Verify bubble cap has not been reached.
        let currentNumberOfBubbles = bubbles.count;
        guard (currentNumberOfBubbles < maxNumberOfBubbles) else {
            return;
        }
        
        // Generate a random number of bubbles within the remaining limit or limited by the number of free positions, whichever is least.
        let screenWidth = UIScreen.main.bounds.width;
        let screenHeight = UIScreen.main.bounds.height;
        let minimumDistance = max(GameHelper.BUBBLE_SIZE, (screenWidth * screenHeight) / CGFloat(maxNumberOfBubbles * 200));
        
        var numberToGenerate = Int.random(in: 1...(maxNumberOfBubbles - currentNumberOfBubbles));
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
    
    private func removeRandomBubbles() {
        // Remove a random number of bubbles, under the condition the number of bubbles on-screen is more than 3.
        guard (bubbles.count >= 3) else {
            return;
        }
        
        withAnimation {
            let randomNumber = Int.random(in: 1...3);
            bubbles.removeFirst(randomNumber);
        }
    }
    
    private func generateRandomBubble(position: CGPoint) -> Bubble {
        // Generate a bubble with random velocity, type and ability.
        let randomVelocity: CGPoint = CGPoint(
            x: CGFloat.random(in: -2...2),
            y: CGFloat.random(in: -2...2)
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
        
        // EF 4 - Generate a special bubble type / ability
        let bubbleAbilities = [
            (BubbleAbilityEnum.None, 90),
            (BubbleAbilityEnum.Bomb, 5),
            (BubbleAbilityEnum.Mimic, 4),
            (BubbleAbilityEnum.ScreenClear, 1)
        ];
        let weightedBubbleAbilities = bubbleAbilities.flatMap { bubble in Array(repeating: bubble.0, count: bubble.1) };
        let randomBubbleAbility = weightedBubbleAbilities.randomElement() ?? .None;
        
        let bubble = Bubble(type: randomBubbleType, ability: randomBubbleAbility, position: position, velocity: randomVelocity);
        return bubble;
    }
}
