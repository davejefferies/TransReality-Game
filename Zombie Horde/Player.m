//
//  Player.m
//  Zombie Horde
//
//  Created by David Jefferies on 12/03/17.
//  Copyright © 2017 David Jefferies. All rights reserved.
//

#import "Player.h"
#import "Sound.h"

@implementation Player {
    Sound *soundManager;
}
@synthesize moveable;
@synthesize speed;
@synthesize hugeTime;
@synthesize attackAnimation;
@synthesize deadAnimation;
@synthesize idleAnimation;
@synthesize jumpAnimation;
@synthesize walkAnimation;
@synthesize attacking;
@synthesize leftTouch;
@synthesize rightTouch;
@synthesize attackTouch;
@synthesize attackLeft;
@synthesize attackRight;
@synthesize character;

+ (id)playerManager {
    static Player *myPlayerManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myPlayerManager = [[self alloc] init];
    });
    
    return myPlayerManager;
}

- (id)init {
    if (self = [super init]) {
        [self setupAnimations];
        soundManager = [Sound soundManager];
    }
    
    return self;
}

- (void)dealloc {
    //Should never be called
}

-(void) touchBegan:(NSSet *)touches withEvent:(UIEvent *)event withSelf:(SKNode *)this {
    for (UITouch *touch in touches) {
        if ([self.attackLeft containsPoint:[touch locationInNode:this]] || [self.attackRight containsPoint:[touch locationInNode:this]]) {
            self.attackTouch = YES;
        } else if ([touch locationInNode:self.character.parent].x < self.character.position.x) {
            self.leftTouch = YES;
        } else if ([touch locationInNode:self.character.parent].x > self.character.position.x) {
            self.rightTouch = YES;
        }
    }
    
    if (self.attackTouch && self.moveable) {
        [soundManager playEffect:@"sword.wav" withSelf:this];
        [self.character runAction: self.attackAnimation completion:^{
            self.attacking = NO;
        }];
        self.attackTouch = NO;
        self.attacking = YES;
        //self.attackCount = 0;
    } else if (self.leftTouch && self.rightTouch && self.moveable) {
        //[soundManager playEffect:@"jump.wav" withSelf:this];
        SKAction *jumpMove = [SKAction applyImpulse:CGVectorMake(5, 140) duration:0.3];
        [self.character runAction:jumpMove];
        [self.character runAction: self.jumpAnimation];
    } else if (self.leftTouch && self.moveable) {
        self.character.xScale = -1.0*ABS(self.character.xScale);
        SKAction *move = [SKAction moveBy:CGVectorMake(-1.0*self.speed*self.hugeTime, 0) duration:self.hugeTime];
        [self.character runAction:move withKey:@"walkAction"];
        [self.character runAction: self.walkAnimation withKey:@"walkAnimation"];
    } else if (self.rightTouch && self.moveable) {
        self.character.xScale = 1.0*ABS(self.character.xScale);
        SKAction *leftMove = [SKAction moveBy:CGVectorMake(1.0*self.speed*self.hugeTime, 0) duration:self.hugeTime];
        [self.character runAction:leftMove withKey:@"walkAction"];
        [self.character runAction: self.walkAnimation withKey:@"walkAnimation"];
    }
}

-(void) touchEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event withSelf:(SKNode *)this {
    for (UITouch *touch in touches) {
        if ([touch locationInNode:self.character.parent].x < self.character.position.x) {
            self.leftTouch = NO;
        } else if ([touch locationInNode:self.character.parent].x > self.character.position.x) {
            self.rightTouch = NO;
        }
    }
    if (!self.leftTouch && !self.rightTouch) {
        [self.character removeActionForKey:@"walkAction"];
        [self.character removeActionForKey:@"walkAnimation"];
    }
}

-(void) setupAnimations {
    NSMutableArray<SKTexture *> *attackTextures = [NSMutableArray new];
    NSMutableArray<SKTexture *> *idleTextures = [NSMutableArray new];
    NSMutableArray<SKTexture *> *jumpTextures = [NSMutableArray new];
    NSMutableArray<SKTexture *> *walkTextures = [NSMutableArray new];
    NSMutableArray<SKTexture *> *deadTextures = [NSMutableArray new];
    for (int i = 1; i <= 10; i++) {
        [attackTextures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"Knight Attack (%d)", i]]];
        [idleTextures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"Knight Idle (%d)", i]]];
        [jumpTextures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"Knight Jump (%d)", i]]];
        [walkTextures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"Knight Walk (%d)", i]]];
        [deadTextures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"Knight Dead (%d)", i]]];
    }
    self.attackAnimation = [SKAction animateWithTextures:attackTextures timePerFrame:0.1];
    self.idleAnimation = [SKAction repeatActionForever:[SKAction animateWithTextures:idleTextures timePerFrame:0.1]];
    self.jumpAnimation = [SKAction animateWithTextures:jumpTextures timePerFrame:0.1];
    self.walkAnimation = [SKAction repeatActionForever:[SKAction animateWithTextures:walkTextures timePerFrame:0.1]];
    self.deadAnimation = [SKAction animateWithTextures:deadTextures timePerFrame:0.1];
}

@end
