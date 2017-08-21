//
//  GameScene.swift
//  Knots
//
//  Created by Martin Tsang on 2017-08-21.
//  Copyright © 2017 Martin Tsang. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    let rock = SKTexture(imageNamed: "rock")
    
    override func didMove(to view: SKView) {
        setupSceneObjects()
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

}
    


