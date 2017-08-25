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
    
    override func didMove(to view: SKView) {
        print("DidMove")
        
        createAnimationBackground()
        creatingStartGameLabel ()
        
        //Audio
       // SKAction.playSoundFileNamed("SFXOpeningOcean", waitForCompletion: false)
        let music: SKAudioNode = SKAudioNode.init(fileNamed: "SFXOpeningOcean.wav")
        music.autoplayLooped = true
        addChild(music)
        
        //Create Top Logo
        createLogo()
    }
    
    func createLogo () {
        let logo = SKSpriteNode(imageNamed: "KnotsTitle")
        logo.position = CGPoint(x:frame.midX, y: 3*frame.height/10)
        addChild(logo)
        
    }
    
    func creatingStartGameLabel () {
        //Setup Score Label
        scoreLabel = SKLabelNode(fontNamed: "AmericanTypewriter")
        scoreLabel.text = "Tap To Start"
        scoreLabel.fontSize = 50
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: frame.midX, y: -3*frame.height/10)
        
        let fadein = SKAction.fadeIn(withDuration: 2)
        let fadeout = SKAction.fadeOut(withDuration: 2)
        let fadeInOut = SKAction.sequence([fadein, fadeout])
        scoreLabel.run(SKAction.repeatForever(fadeInOut))
        
        addChild(scoreLabel)
    }
    
    func createAnimationBackground() {
        // Add all frames
        var frames: [SKTexture] = []
        
        for i in 1...45 {
            let pic:String = "frame_\(i).png"
            frames.append(SKTexture.init(imageNamed:pic))
        }
        
        // Load the first frame as initialization
        let backgroundNode = SKSpriteNode(imageNamed: "frame_0.png")
        backgroundNode.position = CGPoint(x: self.frame.midX, y:self.frame.midY)
        
        //Size
        let aspectRatio = backgroundNode.size.width / backgroundNode.size.height
        
        let backgroundSize:CGSize = CGSize(width: frame.size.width, height: frame.size.width/aspectRatio)
        backgroundNode.scale(to: backgroundSize)
        
        // Change the frame
        let animation = SKAction.animate(with: frames, timePerFrame: 0.05)
        backgroundNode.run(SKAction.repeatForever(animation))
        
        self.addChild(backgroundNode)
    }
    
    
    var pressOnce = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let scene = SKScene(fileNamed: "GameScene") {
            
            if (pressOnce) {return}
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            // Present the scene
            if let view = self.view {

                let music: SKAudioNode = SKAudioNode.init(fileNamed: "fogHorn.wav")
                self.addChild(music)
                pressOnce = true
                
                //Wait
                let wait = SKAction.wait(forDuration: 2)
                
                //Change Scene
                let changeScene = SKAction.run({
                    let transition = SKTransition.fade(withDuration: 1.0)
                    
                    view.presentScene(scene, transition: transition)
                })
                
                //Run All Actions
                self.run(SKAction.sequence([wait,changeScene]))
               
            }
           
        }

    }
    
    
}
