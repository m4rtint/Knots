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
    
    
    init(withSize: BoatSizes) {
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
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
//    
//    init (gameScene:SKScene) {
//        super.init(texture:SKTexture(imageNamed: "smallBoat"), color: SKColor.clear, size: CGSize(width: 20, height: 80))
//        
//        
//        var image: String!
//        
//        if (size.height == 80) {
//
//            image = "smallBoat"
//        } else if (size.height == 100) {
//            
//            image = "midBoat"
//            
//        } else { image = "bigBoat" }
//        
//}
//




