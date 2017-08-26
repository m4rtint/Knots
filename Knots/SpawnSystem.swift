//
//  SpawnSystem.swift
//  Knots
//
//  Created by Martin Tsang on 2017-08-25.
//  Copyright © 2017 Martin Tsang. All rights reserved.
//

import Foundation
import SpriteKit

class SpawnSystem: SKNode {
    
    func spawnBirdManager() {
        
        var birdSpawns:[SKAction] = []
        
        let count = arc4random_uniform(3)+3
        let birdsAnimation = SKAction.run {
            self.createBird()
        }
        
        let wait =  SKAction.wait(forDuration: 30)
        
        for _ in 1...count {
            birdSpawns.append(birdsAnimation)
            birdSpawns.append(SKAction.wait(forDuration: 1))
        }
        birdSpawns.append(wait)
        //Music
        birdSpawns.append(SKAction.playSoundFileNamed("SFXSeagulls.wav",waitForCompletion:false))
        let sequence = SKAction.sequence(birdSpawns)
        scene!.run(SKAction.repeatForever(sequence))
    }
    
    private func createBird() {
        let bird:Bird = Bird()
        scene!.addChild(bird)
        bird.move()
    }
    
    
}
