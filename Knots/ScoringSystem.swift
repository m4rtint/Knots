//
//  ScoringSystem.swift
//  Knots
//
//  Created by Martin Tsang on 2017-08-25.
//  Copyright © 2017 Martin Tsang. All rights reserved.
//

import Foundation
import SpriteKit

class ScoringSystem: SKNode{
    let userDefaults = UserDefaults.standard
    
    var highScore:Int = 0
    var currentScore:Int = 0
    var powerUpScore:Int = 0
    var gmScene:GameScene!
    /*
     
     Score Manager
     
     */
    
    override init () {
        super.init()
        //Setup High score
        if userDefaults.value(forKey: "highScore") != nil{
            highScore = userDefaults.value(forKey: "highScore") as! Int
        } else {
            userDefaults.set(0, forKey: "highScore")
            highScore = 0
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
   //Setup highscore
    func userDefHighScoreUpdate () {
        //Check if High score is the higher than what's stored in userDefaults
        if let currentHighScore = userDefaults.value(forKey: "highScore") as? Int {
            if self.highScore > currentHighScore {
                userDefaults.set(self.highScore, forKey: "highScore")
            }
        }
    }
    
    //updates the score and high score
    public func updateScoreBoatSaved() {
        self.currentScore += 1
        
            //Only add to power Up score if player doesn't have power up
            if !self.gmScene.powerUp  {
                self.powerUpScore += 1
            }
            if self.currentScore > self.highScore {
                self.highScore = self.currentScore
            }
            gmScene.scoreLabel.text = scoreOnLabel()
        
    }
    
    
    func scoreOnLabel() ->String {
        return "Score: \(currentScore)    HighScore: \(highScore)"
    }
    
    func resetScore(){
        self.currentScore = 0
        self.powerUpScore = 0
        self.gmScene.scoreLabel.text = scoreOnLabel()
        
    }


}
