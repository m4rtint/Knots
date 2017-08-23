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
        case small = 40, mid = 60, big = 80
    }
    
    //Model
    var currentHealth: Int
    var maxHealth:Int
    var boatSize:BoatSizes
    var boatOriginLocation:CGPoint
    var boatSpeed:Double = 1.0
    var timer = Timer()
    var countDownText = SKLabelNode(text: "5")
    var countDown:Int = 5
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
        
        maxHealth = withSize.rawValue
        currentHealth = maxHealth
        healthBar = SKSpriteNode(color:SKColor.black, size: CGSize(width: 15, height:CGFloat(withSize.rawValue)))
        
        mySize = CGSize (width: 20, height: CGFloat(withSize.rawValue))
        
        boatOriginLocation = CGPoint()
        
        
        super.init(texture: boatTexture, color: UIColor.clear, size: mySize)
        
        let temp:Int = randomNumber()
        
        boatSpeed = setBoatSpeed(direction: temp, longSideMod: 10, shortSideMod: 15)
        
        
        
        self.position = setPosition(direction: temp, scene: gameScene)
        self.zRotation = boatRotation()
        self.boatOriginLocation = self.position
       // healthBar.position = CGPoint(x: 30 , y: 0)
        
        countDownText = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        countDownText.position = CGPoint(x: 30 , y: -20)
        countDownText.fontColor = SKColor.black
        
        countDown = Int(maxHealth)
        
        setZposition(boat: self, infoBar: healthBar)
       // addChild(healthBar)
        
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
    
//    func updateHealth(change: Int) {
//        if (currentHealth > 0) {
//            currentHealth += change
//        }
//    }
//    
//    func update() {
//        healthBar.size.height = CGFloat(currentHealth);
//    }
//    
    
    //TODO NEED TO SET SAVED/NOT SAVED BOOLEAN
    
    
    
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
    
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector (self.updateTimerDown), userInfo: nil, repeats: true)
        
        
    }
    
    func updateTimerDown () {
        
        if self.isSaved == false {
            if countDown > 0 {
                countDown -= 10
                countDownText.text = String(countDown)
            } else {
                countDownText.text = String(countDown)
                countDownText.isHidden = true
                self.isSaved = true
                print(isSaved)
                self.boatTurnedAround()
                
            }
        }
        
    }
    
    func startTimerRegen() {
        

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector (self.updateTimerRegen), userInfo: nil, repeats: true)
        
    }
    
    func updateTimerRegen () {
        
        if self.isSaved == false {
            if countDown <= maxHealth {
                countDown += 1
                countDownText.text = String(countDown)
            } else {
                
                countDownText.text = String(countDown)
              //  countDownText.isHidden = true
                
                
            }
        }
        
    }
    
    func boatTurnedAround () {
        
        self.removeAllActions()
        let destPoint :CGPoint = self.boatOriginLocation
        let vector1 = CGVector(dx: 0, dy: 1)
        let vector2 = CGVector(dx: destPoint.x - self.position.x, dy: destPoint.y - self.position.y)
        let angle = atan2(vector2.dy, vector2.dx) - atan2(vector1.dy, vector1.dx)
        self.zRotation = angle
        self.run(SKAction.move(to: self.boatOriginLocation, duration: self.boatSpeed))
        
 
        
    }
}
