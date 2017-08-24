//
//  Boat.swift
//  Knots
//
//  Created by Hirad on 2017-08-22.
//  Copyright © 2017 Martin Tsang. All rights reserved.
//

import UIKit
import SpriteKit

class Boat: SKSpriteNode {
    
    //View stuff
    var healthBar:SKSpriteNode!
    enum BoatSizes:Int {
        case small = 2, mid = 4, big = 6
    }
    
    //Model
    var currentHealth: Float
    var maxHealth:Float
    var boatSize:BoatSizes
    var boatOriginLocation:CGPoint
    var boatSpeed:Double = 1.0
    var timer = Timer()
    var countDownText = SKLabelNode(text: "5")
    var countDown:Float = 5
    var isSaved:Bool = false
    var isLit:Bool = false


    
    init(withSize: BoatSizes, gameScene:SKScene) {        
        let boatTexture:SKTexture!
        let mySize:CGSize!
        boatSize = withSize;
        switch withSize {
        case .small:
            boatTexture = SKTexture (imageNamed: "smallBoat")
        case .mid:
            boatTexture = SKTexture (imageNamed: "midBoat")
        case .big:
            boatTexture = SKTexture (imageNamed: "bigBoat")
        }
        
        maxHealth = Float(withSize.rawValue)
        currentHealth = maxHealth
        healthBar = SKSpriteNode(color:SKColor.black, size: CGSize(width: 15, height:CGFloat(withSize.rawValue)))
        
        mySize = CGSize (width: 12, height: CGFloat(withSize.rawValue)*9)
        
        boatOriginLocation = CGPoint()
        
        
        super.init(texture: boatTexture, color: UIColor.clear, size: mySize)
        
        let temp:Int = randomNumber()
        
        boatSpeed = setBoatSpeed(direction: temp, longSideMod: 18, shortSideMod: 20)
        
        
        
        self.position = setPosition(direction: temp, scene: gameScene)
        self.zRotation = boatRotation()
        self.boatOriginLocation = self.position
       // healthBar.position = CGPoint(x: 30 , y: 0)
        
        countDownText = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        countDownText.position = CGPoint(x: 0 , y: -50)
        countDownText.fontColor = SKColor.white
        
        countDown = maxHealth
        
        setZposition(boat: self, infoBar: healthBar)
        
        countDownText.fontSize = 30
        addChild(countDownText)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setPosition(direction: Int, scene: SKScene) -> CGPoint {
        
        
        let gameSpaceWidth:CGFloat = SKTexture(imageNamed: "rock").size().width //setting the size of the game space safe zone.
        let gameSpaceHeight:CGFloat = SKTexture(imageNamed: "rock").size().height //setting the size of the game space safe zone.
        
        var width:CGFloat = scene.size.width
        var height:CGFloat = scene.size.height
        
        var xValue:CGFloat = 0
        var yValue:CGFloat = 0
        
        var randomBinary:CGFloat = 1
        if arc4random_uniform(2) == 0 {
            randomBinary = -1
        }
        
        switch direction {
        case 0: //TOP
            yValue = CGFloat(height/2 + self.size.height)
            width -= gameSpaceWidth*2+self.size.width+100
            xValue = randomBinary * CGFloat(arc4random_uniform(UInt32(width/2)))
            break
        case 1://RIGHT
            xValue = CGFloat(width/2 + self.size.height)
            height -= gameSpaceHeight*2+self.size.width+100
            yValue = randomBinary * CGFloat(arc4random_uniform(UInt32(height/2)))
            break
        case 2://LEFT
            xValue = CGFloat(-width/2 - self.size.height)
            height -= gameSpaceHeight*2+self.size.width+100
            yValue = randomBinary * CGFloat(arc4random_uniform(UInt32(height/2)))
            break
        case 3://BOTTOM
            yValue = CGFloat(-height/2 - self.size.height)
            width -= gameSpaceWidth*2+self.size.width+100
            xValue = randomBinary * CGFloat(arc4random_uniform(UInt32(width/2)))
            break
        default:
            break
        }
        
        
        return CGPoint(x: xValue, y: yValue)
    }
    

    func boatRotation() -> CGFloat {
        let destPoint :CGPoint = CGPoint (x: 0, y: 0)
        let vector1 = CGVector(dx: 0, dy: 1)
        let vector2 = CGVector(dx: destPoint.x - self.position.x, dy: destPoint.y - self.position.y)
        let angle = atan2(vector2.dy, vector2.dx) - atan2(vector1.dy, vector1.dx)
        return angle
        
    }
    
    func setBoatSpeed(direction: Int, longSideMod: Int, shortSideMod: Int) -> Double {
        
        var speed:Int = 1
        
        if (direction == 0 || direction == 3) {
            
            speed = Int(arc4random_uniform(3))+longSideMod
        }
            
        else if (direction == 1 || direction == 2) {
            
            speed = Int(arc4random_uniform(3))+shortSideMod
        }
        return Double(speed)
        
    }
    
    func randomNumber() -> Int{
        
        return Int(arc4random_uniform(4))
    }
    
    func setZposition(boat: Boat, infoBar: SKSpriteNode) {
        
        boat.zPosition = 1
        infoBar.zPosition = 3
        countDownText.zPosition = 3
    }
    
    func startTimerDown() {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.1,
                                     target: self,
                                     selector:#selector (self.updateTimerDown),
                                     userInfo: nil,
                                     repeats: true)
        
    }
    
    func updateTimerDown () {
        if !self.isSaved {
            if countDown > 0 {
                //When counting Down
                countDown -= 0.5
                
                //Show the text
                countDownText.run(SKAction.fadeIn(withDuration: 0.5))
            } else {
                saveBoat(powerUp: false)
            }
        }
        countDownText.text = String(format: "%.2f",abs(countDown))
    }
    
    //Set the properties as saved boat
    func saveBoat(powerUp: Bool) {
        //When boat is saved
        self.alpha = 0.5
        
        //Hide the text
        countDownText.run(SKAction.fadeOut(withDuration: 0.5))
        self.isSaved = true
        self.boatTurnedAround()
        if (!powerUp) {
            let scene = self.scene as? GameScene
            scene?.updateScoreBoatSaved()
        }
        
        self.physicsBody = nil
        
    }
    
    func startTimerRegen() {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector:#selector (self.updateTimerRegen), userInfo: nil, repeats: true)
    }
    
    func updateTimerRegen () {
        if !self.isSaved{
            if countDown < maxHealth {
                countDown += 0.1
                countDownText.run(SKAction.fadeOut(withDuration: 0.5))
            }
        }
         countDownText.text = String(format: "%.2f",abs(countDown))
    }
    
    func boatTurnedAround () {
        self.removeAllActions()
        self.zRotation = self.zRotation + CGFloat.pi
        self.run(SKAction.move(to: self.boatOriginLocation, duration: self.boatSpeed))
    }
}
