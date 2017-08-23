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
    
    
    enum BoatSizes {
        case small, mid, big
    }
    
    
    init(withSize: BoatSizes, gameScene:SKScene) {
        let boatTexture:SKTexture!
        let mySize:CGSize!
        
        switch withSize {
        case .small:
            boatTexture = SKTexture (imageNamed: "smallBoat")
            mySize = CGSize (width: 20, height: 40)
        case .mid:
            boatTexture = SKTexture (imageNamed: "midBoat")
            mySize = CGSize (width: 20, height: 60)
        case .big:
            boatTexture = SKTexture (imageNamed: "bigBoat")
            mySize = CGSize (width: 20, height: 80)
            
        }
        
        super.init(texture: boatTexture, color: UIColor.clear, size: mySize)
        
        self.position = setPosition(direction: (Int(arc4random_uniform(4))), scene: gameScene)
        self.zRotation = boatRotation()
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
        yValue = CGFloat(height/2)
        width -= gameSpaceWidth*2+self.size.width
        xValue = randomBinary * CGFloat(arc4random_uniform(UInt32(width/2)))
        break
    case 1://RIGHT
        xValue = CGFloat(width/2)
        height -= gameSpaceHeight*2+self.size.width
        yValue = randomBinary * CGFloat(arc4random_uniform(UInt32(height/2)))
        break
    case 2://LEFT
        xValue = -CGFloat(width/2)
        height -= gameSpaceHeight*2+self.size.width
        yValue = randomBinary * CGFloat(arc4random_uniform(UInt32(height/2)))
        break
    case 3://BOTTOM
        yValue = -CGFloat(height/2)
        width -= gameSpaceWidth*2+self.size.width
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
}



