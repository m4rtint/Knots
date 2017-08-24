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
    var scoreLabel = SKLabelNode()
    let highScore = 10
    let userDefaults = UserDefaults.standard
    //Tunable Variables
    let lightHouseRotationTimeTaken:Double = 0.5
    
    //Counters
    var numberOfShipsOnFrame:Int = 0
    var currentScore:Int = 0
    var nextRound:Int = 1
    
    struct PhysicsCategories {
        static let None : UInt32 = 0x1 << 0
        static let Frame :UInt32 = 0x1 << 1
        static let Boat : UInt32 = 0x1 << 2
        static let Light : UInt32 = 0x1 << 3
        static let LightHouse : UInt32 = 0x1 << 4
    }
    
    
    override func didMove(to view: SKView) {
        //Setup Physics in this world + remove gravity from the world
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector.zero
        
        //Setup Corner rocks
        setupSceneCornerRocks()
        
        //Setup Lighthouse Collision
        self.lightHouse = self.childNode(withName:"LightHouse") as! SKSpriteNode
        self.lightHouse.physicsBody!.categoryBitMask = PhysicsCategories.LightHouse
        self.lightHouse.physicsBody!.collisionBitMask = PhysicsCategories.Boat
        self.lightHouse.physicsBody!.contactTestBitMask = PhysicsCategories.Boat
        
        //Setup cone of light
        setupConeOfLightProperty()
        
        //Setup Scene Physics
        physicsBody = SKPhysicsBody(rectangleOf: self.size)
        physicsBody!.categoryBitMask = PhysicsCategories.Frame
        physicsBody!.collisionBitMask = PhysicsCategories.None
        physicsBody!.contactTestBitMask = PhysicsCategories.Boat
        
        //Setup Score Label
        scoreLabel = SKLabelNode(fontNamed: "AmericanTypewriter")
        scoreLabel.text = "Score: \(currentScore)"
        scoreLabel.fontSize = 50
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: frame.midX, y: 4*frame.height/10)
        
        addChild(scoreLabel)
        
        //Start up spawn
        spawnController()
    }

    func setupConeOfLightProperty() {
        //Set up cone of light Collision
        self.light = self.lightHouse.childNode(withName: "ConeOfLight") as! SKSpriteNode
        self.light.physicsBody!.categoryBitMask = PhysicsCategories.Light
        self.light.physicsBody!.collisionBitMask = PhysicsCategories.None
        self.light.physicsBody!.contactTestBitMask = PhysicsCategories.Boat
    }
    
    //Set up Rocks on the corner of the screens
    func setupSceneCornerRocks() {
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
            let node = body1.node as! Boat
            if (!node.isLit) {
                print("Light is hitting the boat")
                node.startTimerDown()
                node.isLit = true
            }
        }
        
        if body1.categoryBitMask == PhysicsCategories.Boat &&
            body2.categoryBitMask == PhysicsCategories.LightHouse {
            
            //When a boat hits the Lighthouse
            print ("Boat hit the light house - Game Over")
            self.pauseGame(paused: false)
            
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
            
            let node = body1.node as! Boat
            
            if (node.isLit) {
                print("Light Left boat")
                node.startTimerRegen()
                node.isLit = false
            }
            
            
        }
        
        //Handle any collisions between Nodes
        if body1.categoryBitMask == PhysicsCategories.Frame &&
            body2.categoryBitMask == PhysicsCategories.Boat {
            
            //Ship out of frame
            removeChildren(in: [body2.node!])
            
            //update values
            numberOfShipsOnFrame -= 1
            currentScore += 1
            scoreLabel.text = "Score: \(currentScore)"
        }
    }
    
    /*
     
     Pause and Play game state
     
     
     */
    
    func pauseGame(paused: Bool) {
        self.scene?.isPaused = true
        for object in self.children {
            if let boat = object as? Boat {
                boat.timer.invalidate()
            }
        }
        
        //Adding Restart Button
        var node:SKSpriteNode = SKSpriteNode(texture: SKTexture(imageNamed: "restart"))
        node.position = CGPoint(x: self.frame.midX, y:self.frame.midY-80)
        node.size = CGSize(width: 100, height: 100)
        node.zPosition = 1000
        node.name = "restart"
        addChild(node)
        
        //Added Play Button
        if (paused) {
            node = SKSpriteNode(texture: SKTexture(imageNamed: "play"))
            node.position = CGPoint(x: self.frame.midX, y:self.frame.midY+80)
            node.size = CGSize(width: 100, height: 100)
            node.zPosition = 1000
            node.name = "play"
            addChild(node)
        } else {
            node.position = CGPoint(x: self.frame.midX, y:self.frame.midY)
        }
    }
    
    func resumeGame() {
        self.isPaused = false
        let play:SKNode = childNode(withName: "play")!
        let restart:SKNode = childNode(withName: "restart")!
        removeChildren(in: [play,restart])
    }
    
    func restartGame() {
        for object in self.children {
            if let boat = object as? Boat {
                self.removeChildren(in: [boat])
            }
        }
        
        //Remove buttons
        if let play = childNode(withName: "play") {
            removeChildren(in: [play])
        }
        
        if let restart = childNode(withName: "restart") {
            removeChildren(in: [restart])
        }
        
        //Reset all properties
        self.removeAllActions()
        self.currentScore = 0
        self.nextRound = 1
        scoreLabel.text = "Score: \(currentScore)"
        self.isPaused = false
        spawnController()
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
        
        //Checking For Pause Button
        let objectTouched:[SKNode] = nodes(at: curPoint)
        for object in objectTouched {
            if (object.name == "pause") {
                pauseGame(paused:true)
            }
            if (object.name == "play") {
                resumeGame()
            }
            if (object.name == "restart"){
                object.removeFromParent()
                restartGame()
            }
        }
        if (!self.isPaused){
            rotateLight(currentPoint: curPoint)
        }
    }
    
    func rotateLight (currentPoint:CGPoint ) {
        let deltaX = -currentPoint.x
        let deltaY = -currentPoint.y
        
        let angle = atan2(deltaY,deltaX) + 270 * DegreesToRadians
        
        let rotate = SKAction.rotate(toAngle: angle, duration:lightHouseRotationTimeTaken, shortestUnitArc: true)
        self.lightHouse.run(rotate)
    }
    
    
    /*
     
     
     Spawn Mechanics
     
     
     */
    
    //Called Each one a new round happens
    func spawnController () {
        let waitTimeInbetween:Double = Double(arc4random_uniform(3)+3)
        var arrayOfActions:[SKAction] = []
            
        for _ in 1...4 {
            //Spawn the boat
            //Spawn 4xround number of boats
            for _ in 1...nextRound {
                let spawn = SKAction.run {
                    self.createBoat()
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
    
    func createBoat() {
        var boatSize:Boat.BoatSizes = Boat.BoatSizes.big
        switch arc4random_uniform(3) {
        case 0:
            boatSize = Boat.BoatSizes.small
            break
        case 1:
            boatSize = Boat.BoatSizes.mid
            break;
        case 2:
            boatSize = Boat.BoatSizes.big
            break;
        default:
            boatSize = Boat.BoatSizes.small
        }
        //Create Boat
        let node = Boat.init(withSize: boatSize, gameScene: self)
        
        //Add movement
        node.run(SKAction.move(to: CGPoint(x:0,y:0), duration: node.boatSpeed), withKey: "movement")
        
        //Add Physics
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody!.affectedByGravity = false
        node.physicsBody!.categoryBitMask = PhysicsCategories.Boat
        node.physicsBody!.collisionBitMask = PhysicsCategories.LightHouse | PhysicsCategories.Boat
        node.physicsBody!.contactTestBitMask = PhysicsCategories.Light | PhysicsCategories.Frame
        
        addChild(node)
        
        //increment number of ships
        numberOfShipsOnFrame += 1
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        if (self.currentScore/10 == nextRound) {
            removeAction(forKey: "BoatSpawn")
            nextRound += 1
            spawnController()
        }
       
    }
    
    func highScoreCheck (currentHighScore: Int) {
        
        if let highScore = userDefaults.value(forKey: "highScore") {
            
            if currentHighScore > highScore as! Int {
                userDefaults.set(currentHighScore, forKey: "highScore")
            }
            
        }
    }
    
}


