//
//  Zombie.m
//  Zombie Horde
//
//  Created by David Jefferies on 12/03/17.
//  Copyright © 2017 David Jefferies. All rights reserved.
//

#import "Zombie.h"

@implementation Zombie {
    SKNode *scene;
}

@synthesize speed;
@synthesize deadAnimation;
@synthesize idleAnimation;
@synthesize attackAnimation;
@synthesize walkAnimation;
@synthesize hugeTime;

+ (id)zombieManager:(SKNode *)this {
    static Zombie *myZombieManager = nil;
    //static dispatch_once_t onceToken;
    //dispatch_once(&onceToken, ^{
        myZombieManager = [[self alloc] init:this];
    //});
    
    return myZombieManager;
}

- (id)init:(SKNode *)this {
    if (self = [super init]) {
        scene = this;
        self.speed = 100;
        self.hugeTime = 9999.0;
        [self setupAnimations];
        [self startMoving];
    }
    
    return self;
}

- (void)dealloc {
    //Should never be called
}

-(void) startMoving {
    [scene enumerateChildNodesWithName:@"zombie" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
        node.xScale = 1.0*ABS(node.xScale);
        SKAction *move = [SKAction moveBy:CGVectorMake(1.0*self.speed*self.hugeTime, 0) duration:self.hugeTime];
        [node runAction:move withKey:@"walkAction"];
        [node runAction: self.walkAnimation withKey:@"zombieWalkAnimation"];
    }];
}

-(void) setupAnimations {
    NSMutableArray<SKTexture *> *attackTextures = [NSMutableArray new];
    NSMutableArray<SKTexture *> *idleTextures = [NSMutableArray new];
    NSMutableArray<SKTexture *> *deadTextures = [NSMutableArray new];
    NSMutableArray<SKTexture *> *walkTextures = [NSMutableArray new];
    for (int i = 1; i <= 15; i++) {
        [idleTextures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"Zombie Idle (%d)", i]]];
        if (i < 9)
            [attackTextures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"Zombie Attack (%d)", i]]];
        if (i < 13)
            [deadTextures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"Zombie Dead (%d)", i]]];
        if (i < 11)
            [walkTextures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"Zombie Walk (%d)", i]]];
        self.attackAnimation = [SKAction animateWithTextures:attackTextures timePerFrame:0.1];
        self.idleAnimation = [SKAction repeatActionForever:[SKAction animateWithTextures:idleTextures timePerFrame:0.1]];
        self.deadAnimation = [SKAction animateWithTextures:deadTextures timePerFrame:0.1];
        self.walkAnimation = [SKAction repeatActionForever:[SKAction animateWithTextures:walkTextures timePerFrame:0.1]];
    }
}

@end
