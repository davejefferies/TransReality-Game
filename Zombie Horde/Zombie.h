//
//  Zombie.h
//  Zombie Horde
//
//  Created by David Jefferies on 12/03/17.
//  Copyright © 2017 David Jefferies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface Zombie : NSObject {
    int speed;
    
    NSTimeInterval hugeTime;
    
    SKAction *attackAnimation;
    SKAction *deadAnimation;
    SKAction *idleAnimation;
    SKAction *jumpAnimation;
    SKAction *walkAnimation;
}

@property (nonatomic) int speed;

@property (nonatomic) NSTimeInterval hugeTime;

@property (nonatomic) SKAction *attackAnimation;
@property (nonatomic) SKAction *deadAnimation;
@property (nonatomic) SKAction *idleAnimation;
@property (nonatomic) SKAction *walkAnimation;

+ (id)zombieManager:(SKNode *)this;

@end
