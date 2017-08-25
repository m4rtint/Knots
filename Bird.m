//
//  Bird.m
//  Knots
//
//  Created by Hirad on 2017-08-24.
//  Copyright © 2017 Martin Tsang. All rights reserved.
//

#import "Bird.h"

@interface Bird ()

@property float startingPosX;
@property float startingPosY;

@end

@implementation Bird


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.texture = [SKTexture textureWithImageNamed:@"Bird"];
        self.size = CGSizeMake(50, 30);
        _startingPosX = (float)arc4random_uniform(300)*(arc4random() % 2 ? 1 : -1);
        _startingPosY = (float)(arc4random() % 2 ? 1 : -1) * arc4random_uniform(1000);
        self.position = CGPointMake(_startingPosX, _startingPosY);
   
        
    }
    return self;
}


- (void) moveBird {
    
    
    float startingPos = self.position.y;
    
    float tempFloat = arc4random_uniform(700);
    
    if (startingPos > 0 ) {
        
        tempFloat = tempFloat * -1;
        
    }
    
    
    SKAction *moveAction = [SKAction moveTo:CGPointMake((float)(arc4random() % 2 ? 1 : -1)*(arc4random_uniform(300)), 1000 + tempFloat ) duration:7];
    //[self runAction:moveAction];
    
    SKAction *delay = [SKAction waitForDuration:7];
    SKAction *remove = [SKAction removeFromParent];

    SKAction *moveSequence = [SKAction sequence:@[moveAction,delay, remove]];
    [self runAction:moveSequence];
    NSLog(@"Birds positions is: %f",self.position.x);
    

}


@end
