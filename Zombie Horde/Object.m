//
//  Object.m
//  Zombie Horde
//
//  Created by David Jefferies on 12/03/17.
//  Copyright © 2017 David Jefferies. All rights reserved.
//

#import "Object.h"

@implementation Object
@synthesize fireArray;
@synthesize smallCoinAnimation;
@synthesize smokeNode;
@synthesize speed;
@synthesize hugeTime;
@synthesize floatHit;
@synthesize floatCharacter;
@synthesize leftFloat;

+ (id)objectManager {
    static Object *myObjectManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myObjectManager = [[self alloc] init];
    });
    
    return myObjectManager;
}

- (id)init {
    if (self = [super init]) {
        self.speed = 50;
        self.hugeTime = 9999.0;
        self.floatHit = NO;
        self.floatCharacter = NO;
        self.leftFloat = NO;
        [self setupAnimations];
    }
    
    return self;
}

- (void)dealloc {
    //Should never be called
}

-(void) setupAnimations {
    NSMutableArray<SKTexture *> *smallCoinTextures = [NSMutableArray new];
    for (int i = 1; i <= 8; i++) {
        [smallCoinTextures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"Small Coin (%d)", i]]];
    }
    self.smallCoinAnimation = [SKAction repeatActionForever:[SKAction animateWithTextures:smallCoinTextures timePerFrame:0.1]];
}

-(void) setupParticles:(SKNode *)this {
    self.fireArray = [NSMutableArray new];
    [this enumerateChildNodesWithName:@"fire" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
        NSString *particlePath = [[NSBundle mainBundle] pathForResource:@"FireParticle" ofType:@"sks"];
        SKEmitterNode *particle = [NSKeyedUnarchiver unarchiveObjectWithFile:particlePath];
        particle.position = CGPointMake(node.position.x, node.position.y);
        particle.zPosition = 1;
        particle.xScale = 0.7;
        particle.yScale = 0.7;
        [self.fireArray addObject:particle];
    }];
    
    for (SKEmitterNode *item in self.fireArray) {
        [this addChild:item];
    }
    
    SKEmitterNode *node = (SKEmitterNode *)[this childNodeWithName:@"smoke"];
    NSString *particlePath = [[NSBundle mainBundle] pathForResource:@"SmokeParticle" ofType:@"sks"];
    self.smokeNode = [NSKeyedUnarchiver unarchiveObjectWithFile:particlePath];
    self.smokeNode.position = CGPointMake(node.position.x, node.position.y);
    self.smokeNode.zPosition = 5;
    [this addChild:self.smokeNode];
}

-(void) setupCollectibles:(SKNode *)this {
    [this enumerateChildNodesWithName:@"small-coin" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
        
        [node runAction: self.smallCoinAnimation];
    }];
}

-(void) setupFloating:(SKNode *)this {
    [this enumerateChildNodesWithName:@"hfloat" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
        node.xScale = 1.0*ABS(node.xScale);
        SKAction *move = [SKAction moveBy:CGVectorMake(1.0*self.speed*self.hugeTime, 0) duration:self.hugeTime];
        [node runAction:move withKey:@"floating"];
    }];
}

@end

