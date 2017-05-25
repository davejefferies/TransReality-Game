//
//  Player.h
//  Zombie Horde
//
//  Created by David Jefferies on 12/03/17.
//  Copyright © 2017 David Jefferies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface Player : NSObject {
    bool attacking;
    NSTimeInterval hugeTime;
    bool moveable;
    int speed;
    bool leftTouch;
    bool rightTouch;
    bool attackTouch;
    
    SKNode *attackLeft;
    SKNode *attackRight;
    SKNode *character;
    
    SKAction *attackAnimation;
    SKAction *deadAnimation;
    SKAction *idleAnimation;
    SKAction *jumpAnimation;
    SKAction *walkAnimation;
}

@property (nonatomic) bool attacking;
@property (nonatomic) NSTimeInterval hugeTime;
@property (nonatomic) bool moveable;
@property (nonatomic) int speed;
@property (nonatomic) bool leftTouch;
@property (nonatomic) bool rightTouch;
@property (nonatomic) bool attackTouch;

@property (nonatomic) SKNode *attackLeft;
@property (nonatomic) SKNode *attackRight;
@property (nonatomic) SKNode *character;

@property (nonatomic) SKAction *attackAnimation;
@property (nonatomic) SKAction *deadAnimation;
@property (nonatomic) SKAction *idleAnimation;
@property (nonatomic) SKAction *jumpAnimation;
@property (nonatomic) SKAction *walkAnimation;

+ (id)playerManager;

-(void) touchBegan:(NSSet *)touches withEvent:(UIEvent *)event withSelf:(SKNode *)this;
-(void) touchEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event withSelf:(SKNode *)this;

@end
