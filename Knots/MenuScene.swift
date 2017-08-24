//
//  MenuScene.swift
//  Knots
//
//  Created by Martin Tsang on 2017-08-23.
//  Copyright © 2017 Martin Tsang. All rights reserved.
//

import Foundation
import SpriteKit

class MenuScene: SKScene {
    
    var scoreLabel = SKLabelNode()
    
    override func sceneDidLoad() {
        print("load scene")
    }
    
    override func didMove(to view: SKView) {
        print("DidMove")
        // Add 3 frames
        var frames: [SKTexture] = []
        
        for i in 1...20 {
            let pic:String = "frame_\(i).png"
            frames.append(SKTexture.init(imageNamed:pic))
        }
        
        // Load the first frame as initialization
        let backgroundNode = SKSpriteNode(imageNamed: "frame_1.png")
        backgroundNode.position = CGPoint(x: self.frame.midX, y:self.frame.midY)
        
        //Size
        let aspectRatio = backgroundNode.size.width / backgroundNode.size.height
        
        let backgroundSize:CGSize = CGSize(width: frame.size.width, height: frame.size.width/aspectRatio)
        backgroundNode.scale(to: backgroundSize)

        // Change the frame
        let animation = SKAction.animate(with: frames, timePerFrame: 0.05)
        backgroundNode.run(SKAction.repeatForever(animation))
        
        self.addChild(backgroundNode)
        
        
        //Label
        
        //Setup Score Label
        scoreLabel = SKLabelNode(fontNamed: "AmericanTypewriter")
        scoreLabel.text = "Tap To Start"
        scoreLabel.fontSize = 50
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: frame.midX, y: -2*frame.height/10)
        
        let fadein = SKAction.fadeIn(withDuration: 1)
        let fadeout = SKAction.fadeOut(withDuration: 1)
        let fadeInOut = SKAction.sequence([fadein, fadeout])
        scoreLabel.run(SKAction.repeatForever(fadeInOut))
        
        addChild(scoreLabel)
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let scene = SKScene(fileNamed: "GameScene") {
        
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            // Present the scene
            if let view = self.view {
                
                let transition = SKTransition.fade(withDuration: 1.0)
                view.presentScene(scene, transition: transition)
            }
           
        }

    }
    
    
}
