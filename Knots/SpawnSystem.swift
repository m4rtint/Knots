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
    
//    //Called Each one a new round happens
//    func spawnBoatController () {
//        let waitTimeInbetween:Double = Double(arc4random_uniform(3)+3)
//        var arrayOfActions:[SKAction] = []
//        
//        for _ in 1...4 {
//            //Spawn the boat
//            //Spawn 4xround number of boats
//            for _ in 1...nextRound {
//                let spawn = SKAction.run {
//                    self.createBoat()
//                }
//                arrayOfActions.append(spawn)
//                
//                if (arc4random_uniform(2) == 0) {
//                    //Wait time between all boats
//                    let waitToSpawn = SKAction.wait(forDuration: waitTimeInbetween)
//                    arrayOfActions.append(waitToSpawn)
//                }
//            }
//            
//            //Whether or not there's wait time between spawning more boats
//            if (arc4random_uniform(2) == 0) {
//                //Wait time between all boats
//                let waitToSpawn = SKAction.wait(forDuration: waitTimeInbetween)
//                arrayOfActions.append(waitToSpawn)
//            }
//        }
//        let spawnSequence = SKAction.sequence(arrayOfActions)
//        let spawnForever = SKAction.repeatForever(spawnSequence)
//        self.run(spawnForever, withKey:"BoatSpawn")
//    }
//    
//    private func createBoat() {
//        var boatSize:Boat.BoatSizes = Boat.BoatSizes.big
//        switch arc4random_uniform(3) {
//        case 0:
//            boatSize = Boat.BoatSizes.small
//            break
//        case 1:
//            boatSize = Boat.BoatSizes.mid
//            break;
//        case 2:
//            boatSize = Boat.BoatSizes.big
//            break;
//        default:
//            boatSize = Boat.BoatSizes.small
//        }
//        //Create Boat
//        let node = Boat.init(withSize: boatSize, gameScene: scene)
//        
//        //Add movement
//        node.run(SKAction.move(to: CGPoint(x:0,y:0), duration: node.boatSpeed), withKey: "movement")
//        
//        //Add Physics
//        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
//        node.physicsBody!.affectedByGravity = false
//        node.physicsBody!.categoryBitMask = scene.PhysicsCategories.Boat
//        node.physicsBody!.collisionBitMask = scene.PhysicsCategories.LightHouse
//        node.physicsBody!.contactTestBitMask = scene.PhysicsCategories.Light | scene.PhysicsCategories.Frame
//        
//        addChild(node)
//        
//    }
    
    
}
