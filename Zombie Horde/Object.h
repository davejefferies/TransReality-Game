//
//  Object.h
//  Zombie Horde
//
//  Created by David Jefferies on 12/03/17.
//  Copyright © 2017 David Jefferies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface Object : NSObject {
    NSMutableArray *fireArray;
    SKEmitterNode *smokeNode;
    SKAction *smallCoinAnimation;
    int speed;
    NSTimeInterval hugeTime;
    bool floatHit;
    bool floatCharacter;
    bool leftFloat;
}

@property (nonatomic) NSMutableArray *fireArray;
@property (nonatomic) SKEmitterNode *smokeNode;
@property (nonatomic) SKAction *smallCoinAnimation;
@property (nonatomic) int speed;
@property (nonatomic) NSTimeInterval hugeTime;
@property (nonatomic) bool floatHit;
@property (nonatomic) bool floatCharacter;
@property (nonatomic) bool leftFloat;

+ (id)objectManager;

-(void) setupParticles:(SKNode *)this;
-(void) setupCollectibles:(SKNode *)this;
-(void) setupFloating:(SKNode *)this;

@end
