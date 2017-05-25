//
//  LevelClass.m
//  Zombie Horde
//
//  Created by David Jefferies on 15/03/17.
//  Copyright © 2017 David Jefferies. All rights reserved.
//

#import "LevelClass.h"
#import "Object.h"
#import "Player.h"
#import "Display.h"
#import "Collision.h"
#import "Zombie.h"
#import "Sound.h"

@implementation LevelClass {
    Object *objectManager;
    Player *playerManager;
    Display *displayManager;
    Collision *collisionManager;
    Zombie *zombieManager;
    Sound *soundManager;
}

@synthesize coinCount;
@synthesize zombieCount;

- (void)didMoveToView:(SKView *)view {
    self.physicsBody.collisionBitMask = 0x0;
    self.physicsBody.contactTestBitMask = 0x0;
    self.physicsWorld.contactDelegate = self;
    
    self.coinCount = 0;
    self.zombieCount = 0;
    
    objectManager = [Object objectManager];
    playerManager = [Player playerManager];
    displayManager = [Display displayManager:self];
    collisionManager = [Collision collisionManager:self];
    zombieManager = [Zombie zombieManager:self];
    soundManager = [Sound soundManager];
    
    [soundManager play:@"Mushroom Theme" withType:@"mp3"];
    
    [objectManager setupParticles:self];
    [objectManager setupCollectibles:self];
    [objectManager setupFloating:self];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [playerManager touchBegan:touches withEvent:event withSelf:self];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [playerManager touchEnded:touches withEvent:event withSelf:self];
    [collisionManager touchEnded:touches withEvent:event withSelf:self];
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    [collisionManager beganContact:contact withSelf:self];
}

- (void)update:(NSTimeInterval)currentTime {
    [displayManager update];
    [collisionManager update];
}

@end
