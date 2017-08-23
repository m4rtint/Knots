//
//  GameScene.swift
//  Knots
//
//  Created by Martin Tsang on 2017-08-21.
//  Copyright © 2017 Martin Tsang. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    //Static Variables
    let rock = SKTexture(imageNamed: "rock")
    let DegreesToRadians = CGFloat.pi / 180
    var light = SKSpriteNode()
    var lightHouse = SKSpriteNode()
    
    //Debug
    var ship = SKSpriteNode()
    
    //Tunable Variables
    let lightHouseRotationTimeTaken:Double = 1
    
    struct PhysicsCategories {
        static let None : UInt32 = 0   // 0
        static let Boat : UInt32 = 0b1 //1
        static let Light : UInt32 = 0b10 //2
        static let LightHouse : UInt32 = 0b100 //4
    }
    
    
    override func didMove(to view: SKView) {
        //Setup Physics in this world
        self.physicsWorld.contactDelegate = self
        
        //Setup Corner rocks
        setupSceneObjects()
        
        //Setup Lighthouse Collision
        self.lightHouse = self.childNode(withName:"LightHouse") as! SKSpriteNode
        self.lightHouse.physicsBody = SKPhysicsBody(rectangleOf: lightHouse.size)
        self.lightHouse.physicsBody!.affectedByGravity = false
        self.lightHouse.physicsBody!.categoryBitMask = PhysicsCategories.LightHouse
        self.lightHouse.physicsBody!.collisionBitMask = PhysicsCategories.Boat
        self.lightHouse.physicsBody!.contactTestBitMask = PhysicsCategories.Boat
        
        
        //Set up cone of light Collision
        self.light = self.childNode(withName: "ConeOfLight") as! SKSpriteNode
        self.light.physicsBody = SKPhysicsBody(rectangleOf: light.size)
        self.light.physicsBody!.affectedByGravity = false
        self.light.physicsBody!.categoryBitMask = PhysicsCategories.Light
        self.light.physicsBody!.collisionBitMask = PhysicsCategories.None
        self.light.physicsBody!.contactTestBitMask = PhysicsCategories.Boat
        
        
        //DEBUG=============
//        self.ship = self.childNode(withName:"ship") as! SKSpriteNode
//        self.ship.physicsBody = SKPhysicsBody(rectangleOf: ship.size)
//        self.ship.physicsBody!.affectedByGravity = false
//        self.ship.physicsBody!.categoryBitMask = PhysicsCategories.Boat
//        self.ship.physicsBody!.collisionBitMask = PhysicsCategories.LightHouse
//        self.ship.physicsBody!.contactTestBitMask = PhysicsCategories.Light
    }
    
    //Set up Rocks on the corner of the screens
    func setupSceneObjects() {
        //TODO SET UP THE ROCK SIZES
        //Set the x+y coordinate
        //Top Left
        var xCoordinate:CGFloat = -(self.size.width/2)+(rock.size().width/2)
        var yCoordinate:CGFloat = (self.size.height/2)-(rock.size().height/2)
            
        var node = SKSpriteNode(texture: rock)
        node.position = CGPoint(x: xCoordinate, y:yCoordinate)
        addChild(node)
        
        //Top Right
        xCoordinate = (self.size.width/2)-(rock.size().width/2)
        yCoordinate = (self.size.height/2)-(rock.size().height/2)
        
        node = SKSpriteNode(texture: rock)
        node.position = CGPoint(x: xCoordinate, y:yCoordinate)
        addChild(node)
        
        //Bottom left
        xCoordinate = -(self.size.width/2)+(rock.size().width/2)
        yCoordinate = -(self.size.height/2)+(rock.size().height/2)
        
        node = SKSpriteNode(texture: rock)
        node.position = CGPoint(x: xCoordinate, y:yCoordinate)
        addChild(node)
        
        //Bottom Right
        xCoordinate = (self.size.width/2)-(rock.size().width/2)
        yCoordinate = -(self.size.height/2)+(rock.size().height/2)
        
        node = SKSpriteNode(texture: rock)
        node.position = CGPoint(x: xCoordinate, y:yCoordinate)
        addChild(node)
    }
    
    
    /*
 
 
        Handling All Collision
 
 
    */
    
    //Called when 2 physics bodies (Nodes) make contact
    func didBegin(_ contact: SKPhysicsContact) {
        //Setup and assign bodies
        //Body 1 will always be the lower physics category
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            body1 = contact.bodyA
            body2 = contact.bodyB
        } else {
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        //Handle any collisions between Nodes
        if body1.categoryBitMask == PhysicsCategories.Boat &&
            body2.categoryBitMask == PhysicsCategories.Light {
            
            //if light hits boat
            print("Light is hitting the boat")
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        //Setup and assign bodies
        //Body 1 will always be the lower physics category
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            body1 = contact.bodyA
            body2 = contact.bodyB
        } else {
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        //Handle any collisions between Nodes
        if body1.categoryBitMask == PhysicsCategories.Boat &&
            body2.categoryBitMask == PhysicsCategories.Light {
            
            //light hits boat
            print("Light Left boat")
        }
        
        if body1.categoryBitMask == PhysicsCategories.Boat &&
            body2.categoryBitMask == PhysicsCategories.LightHouse {
            
            //When a boat hits the Lighthouse
            print ("Boat hit the light house")
        }
    }

    
    
    /*
 
 
     Handling Light + Light house control
 
 
    */
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let curTouch = touches.first!
        let curPoint = curTouch.location(in: self)
        
        rotateLight(currentPoint: curPoint)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let curTouch = touches.first!
        let curPoint = curTouch.location(in: self)
        
        rotateLight(currentPoint: curPoint)
    }
    
    func rotateLight (currentPoint:CGPoint ) {
        let deltaX = self.light.position.x - currentPoint.x
        let deltaY = self.light.position.y - currentPoint.y
        
        let angle = atan2(deltaY,deltaX) + 270 * DegreesToRadians
        
        let rotate = SKAction.rotate(toAngle: angle, duration:lightHouseRotationTimeTaken, shortestUnitArc: true)
        self.light.run(rotate)
        
        print("hello")
    }

}
    


