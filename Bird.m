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
@property Boolean top;

@end

@implementation Bird


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.texture = [SKTexture textureWithImageNamed:@"Bird"];
        self.size = CGSizeMake(50, 30);
        self.top = arc4random_uniform(2)% 2 == 0;
        
        int negative = arc4random_uniform(10)% 2 == 0 ? 1 : -1;
        self.startingPosX = negative * (int)arc4random_uniform(414);
        if(self.top){
            self.startingPosY = 468;
        } else {
            self.startingPosY = -468;
        }
        self.position = CGPointMake(_startingPosX, _startingPosY);
    }
    return self;
}


- (void) moveBird {

    CGPoint destination;
    int negative = arc4random_uniform(10)% 2 == 0 ? 1 : -1;
    destination.x = negative * (float)arc4random_uniform(207);
    if(!self.top){
        destination.y = 468;
    } else {
        destination.y = -468;
    }
    
    SKAction *moveAction = [SKAction moveTo:destination duration:7];
    
    SKAction *delay = [SKAction waitForDuration:7];
    SKAction *remove = [SKAction removeFromParent];
    
    SKAction *moveSequence = [SKAction sequence:@[moveAction,delay, remove]];
    [self runAction:moveSequence];
    
    
}


@end
