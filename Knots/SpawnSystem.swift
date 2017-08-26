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
    var gmScene:GameScene!

    
    /*
 
     Bird Spawn Manager
 
 
    */
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
    
    
    
    
    /*
     
     
     Boat Spawn Mechanics
     
     
     */
    
    //Called Each one a new round happens
    func spawnBoatController () {
        let waitTimeInbetween:Double = Double(arc4random_uniform(3)+3)
        var arrayOfActions:[SKAction] = []
        
        for _ in 1...4 {
            //Spawn the boat
            //Spawn 4xround number of boats
            for _ in 1...gmScene.nextRound {
                let spawn = SKAction.run {
                    self.gmScene.createBoat()
                }
                arrayOfActions.append(spawn)
                
                if (arc4random_uniform(2) == 0) {
                    //Wait time between all boats
                    let waitToSpawn = SKAction.wait(forDuration: waitTimeInbetween)
                    arrayOfActions.append(waitToSpawn)
                }
            }
            
            //Whether or not there's wait time between spawning more boats
            if (arc4random_uniform(2) == 0) {
                //Wait time between all boats
                let waitToSpawn = SKAction.wait(forDuration: waitTimeInbetween)
                arrayOfActions.append(waitToSpawn)
            }
        }
        let spawnSequence = SKAction.sequence(arrayOfActions)
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever, withKey:"BoatSpawn")
    }
}
