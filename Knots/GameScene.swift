//
//  GameScene.swift
//  Knots
//
//  Created by Martin Tsang on 2017-08-21.
//  Copyright © 2017 Martin Tsang. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    //Static Variables
    let rock = SKTexture(imageNamed: "rock")
    let DegreesToRadians = CGFloat.pi / 180
    var light = SKSpriteNode()
    
    //Tunable Variables
    let lightHouseRotationTimeTaken:Double = 1
    
    
    override func didMove(to view: SKView) {
        //Setup Corner rocks
        setupSceneObjects()
        
        //Set up cone of light on scene
        self.light = self.childNode(withName: "ConeOfLight") as! SKSpriteNode
        
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
    }


}
    


