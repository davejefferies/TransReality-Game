//
//  Collision.m
//  Zombie Horde
//
//  Created by David Jefferies on 12/03/17.
//  Copyright © 2017 David Jefferies. All rights reserved.
//

#import "Collision.h"
#import "Object.h"
#import "Player.h"
#import "Zombie.h"
#import "Sound.h"
#import "MainMenu.h"
#import "LevelClass.h"
#import "Data-Level.h"
#import "Data-Achievement.h"
#import "AchievementsClass.h"

@implementation Collision {
    Object *objectManager;
    Player *playerManager;
    Zombie *zombieManager;
    Sound *soundManager;
    Data_Level *dataLevelManager;
    Data_Achievement *dataAchievementManager;
    AchievementsClass *achievementMananger;
    SKNode *scene;
}

+ (id)collisionManager:(SKNode *)this {
    static Collision *myCollisionManager = nil;
    //static dispatch_once_t onceToken;
    //dispatch_once(&onceToken, ^{
        myCollisionManager = [[self alloc] init:this];
    //});
    
    return myCollisionManager;
}

- (id)init:(SKNode *)this {
    //if (self = [super init]) {
    objectManager = [Object objectManager];
    playerManager = [Player playerManager];
    zombieManager = [Zombie zombieManager:this];
    soundManager = [Sound soundManager];
    dataLevelManager = [Data_Level dataLevelManager];
    dataAchievementManager = [Data_Achievement dataAchievementManager];
    achievementMananger = [AchievementsClass achievementsManager];
    scene = this;
    //}
    
    return self;
}

- (void)dealloc {
    //Should never be called
}

- (void)beganContact:(SKPhysicsContact *)contact withSelf:(SKNode *)this {
    NSString *nameA = contact.bodyA.node.name;
    NSString *nameB = contact.bodyB.node.name;
    SKNode *nodeA = contact.bodyA.node;
    SKNode *nodeB = contact.bodyB.node;
    
    if ((([nameB isEqualToString:@"zombie"] && [nameA isEqualToString:@"character"]) || ([nameB isEqualToString:@"szombie"] && [nameA isEqualToString:@"character"])) && !playerManager.attacking) {
        [self characterDead:nodeA withZombie:nodeB];
    } else if ((([nameA isEqualToString:@"zombie"] && [nameB isEqualToString:@"character"]) || ([nameA isEqualToString:@"szombie"] && [nameB isEqualToString:@"character"])) && !playerManager.attacking) {
        [self characterDead:nodeB withZombie:nodeA];
    } else if ((([nameA isEqualToString:@"zombie"] && [nameB isEqualToString:@"character"]) || ([nameA isEqualToString:@"szombie"] && [nameB isEqualToString:@"character"])) && playerManager.attacking) {
        [self attackZombie:nodeA withSelf:this];
    } else if ((([nameB isEqualToString:@"zombie"] && [nameA isEqualToString:@"character"]) || ([nameB isEqualToString:@"szombie"] && [nameA isEqualToString:@"character"])) && playerManager.attacking) {
        [self attackZombie:nodeB withSelf:this];
    } else if ([nameA isEqualToString:@"character"] && [nameB isEqualToString:@"small-coin"] && nodeB.zPosition != 0) {
        [self collectCoin:nodeB];
    } else if ([nameB isEqualToString:@"character"] && [nameA isEqualToString:@"small-coin"] && nodeA.zPosition != 0) {
        [self collectCoin:nodeA];
    } else if ([nameA isEqualToString:@"zombie"] && [nameB isEqualToString:@"wall"]) {
        [self turnZombie:nodeA withWall:nodeB];
    } else if ([nameB isEqualToString:@"zombie"] && [nameA isEqualToString:@"wall"]) {
        [self turnZombie:nodeB withWall:nodeA];
    } else if (([nameB isEqualToString:@"hfloat"] && [nameA isEqualToString:@"character"]) || ([nameB isEqualToString:@"character"] && [nameA isEqualToString:@"hfloat"])) {
        //NSLog(@"YES");
        objectManager.floatCharacter = YES;
    } else {
        objectManager.floatCharacter = NO;
    }
}

-(void) touchEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event withSelf:(SKNode *)this {
    if (!playerManager.moveable) {
        for (UITouch *t in touches) {
            CGPoint pos = [t locationInNode:this];
            SKLabelNode *labelHome = (SKLabelNode *)[this childNodeWithName:@"btnHome"];
            SKLabelNode *labelRestart = (SKLabelNode *)[this childNodeWithName:@"btnRestart"];
            SKLabelNode *labelNext = (SKLabelNode *)[this childNodeWithName:@"btnNext"];
            if ([labelHome containsPoint:pos]) {
                [self showHome:this];
            } else if ([labelRestart containsPoint:pos]) {
                [self restartLevel:this];
            } else if ([labelNext containsPoint:pos]) {
                [self nextLevel:this];
            }
        }
    }
}

-(void) showHome:(SKNode *)this {
    [soundManager stop];
    [this removeActionForKey:@"backgroundAudio"];
    SKView *skView = (SKView *)this.scene.view;
    [this removeFromParent];
    GKScene *s = [GKScene sceneWithFileNamed:@"MainMenu"];
    MainMenu *sceneNode = (MainMenu *)s.rootNode;
    sceneNode.scaleMode = SKSceneScaleModeAspectFit;
    [skView presentScene:sceneNode];
}

-(void) restartLevel:(SKNode *)this {
    int i = [dataLevelManager levelCount] + 1;
    [soundManager stop];
    [this removeActionForKey:@"backgroundAudio"];
    SKView *skView = (SKView *)this.scene.view;
    [this removeFromParent];
    GKScene *s = [GKScene sceneWithFileNamed:[NSString stringWithFormat:@"Level%d", i]];
    LevelClass *sceneNode = (LevelClass *)s.rootNode;
    sceneNode.scaleMode = SKSceneScaleModeAspectFit;
    [skView presentScene:sceneNode];
}

-(void) nextLevel:(SKNode *)this {
    int i = [dataLevelManager levelCount] + 1;
    [soundManager stop];
    [this removeActionForKey:@"backgroundAudio"];
    SKView *skView = (SKView *)this.scene.view;
    [this removeFromParent];
    GKScene *s = [GKScene sceneWithFileNamed:[NSString stringWithFormat:@"Level%d", i]];
    LevelClass *sceneNode = (LevelClass *)s.rootNode;
    sceneNode.scaleMode = SKSceneScaleModeAspectFit;
    [skView presentScene:sceneNode];
}

-(void) attackZombie:(SKNode *)zombie withSelf:(SKNode *)this {
    [zombie setZPosition:0.0];
    [zombie removeAllActions];
    [soundManager playEffect:@"zombie-death.mp3" withSelf:this];
    zombie.physicsBody.affectedByGravity = NO;
    zombie.physicsBody.contactTestBitMask = 0;
    zombie.physicsBody.collisionBitMask = 0;
    zombie.physicsBody.categoryBitMask = 0;
    [zombie runAction: zombieManager.deadAnimation];
}

-(void) characterDead:(SKNode *)character withZombie:(SKNode *)zombie {
    [zombie removeAllActions];
    [self showLose];
}

-(void) collectCoin:(SKNode *)coin {
    [coin setZPosition:0.0];
    coin.physicsBody.contactTestBitMask = 0;
    coin.physicsBody.collisionBitMask = 0;
    coin.physicsBody.categoryBitMask = 0;
    SKLabelNode *label = (SKLabelNode*)[scene childNodeWithName:@"coin-label"];
    SKAction *moveCoin = [SKAction moveTo:[scene childNodeWithName:@"coin"].position duration:0.5];
    SKAction *actionSequence = [SKAction sequence:@[moveCoin, [SKAction fadeOutWithDuration:0.2]]];
    [coin runAction:actionSequence];
    //NSLog(@"%d", [label.text intValue]);
    int cnt = [label.text intValue] + 1;
    //NSLog(@"%d", cnt);
    [label setText: [NSString stringWithFormat:@"%03d", cnt]];
}

-(void) turnZombie:(SKNode *)zombie withWall:(SKNode *)wall {
    if (zombie.frame.origin.x + zombie.frame.size.width <= wall.frame.origin.x + 20) {
        zombie.xScale = -1.0*ABS(zombie.xScale);
        SKAction *move = [SKAction moveBy:CGVectorMake(-1.0*zombieManager.speed*zombieManager.hugeTime, 0) duration:zombieManager.hugeTime];
        [zombie runAction:move withKey:@"walkAction"];
        [zombie runAction: zombieManager.walkAnimation withKey:@"walkAnimation"];
    } else {
        zombie.xScale = 1.0*ABS(zombie.xScale);
        SKAction *move = [SKAction moveBy:CGVectorMake(1.0*zombieManager.speed*zombieManager.hugeTime, 0) duration:zombieManager.hugeTime];
        [zombie runAction:move withKey:@"walkAction"];
        [zombie runAction: zombieManager.walkAnimation withKey:@"walkAnimation"];
    }
}

-(void) update {
    if (!playerManager.moveable)
        return;
    for (SKEmitterNode *item in objectManager.fireArray) {
        if ([item containsPoint:playerManager.character.position] && playerManager.moveable) {
            [self showLose];
        }
    }
    
    if (objectManager.smokeNode.frame.origin.x + (objectManager.smokeNode.frame.size.width / 2) < playerManager.character.frame.origin.x + (playerManager.character.frame.size.width / 2)) {
        [self showWin];
    }
    
    SKNode *lBlock = [scene childNodeWithName:@"flblock"];
    SKNode *rBlock = [scene childNodeWithName:@"frblock"];
    SKNode *flObj = [scene childNodeWithName:@"hfloat"];
    SKNode *c = [scene childNodeWithName:@"character"];
    if ((rBlock.position.x - rBlock.frame.size.width / 2) <= (flObj.position.x + flObj.frame.size.width / 2) && !objectManager.floatHit) {
        objectManager.floatHit = YES;
        objectManager.leftFloat = YES;
        SKAction *move = [SKAction moveBy:CGVectorMake(-1.0*objectManager.speed*objectManager.hugeTime, 0) duration:objectManager.hugeTime];
        [flObj runAction:move withKey:@"floating"];
    } else if ((lBlock.position.x + lBlock.frame.size.width / 2) >= (flObj.position.x - flObj.frame.size.width / 2) && !objectManager.floatHit) {
        objectManager.floatHit = YES;
        objectManager.leftFloat = NO;
        SKAction *move = [SKAction moveBy:CGVectorMake(1.0*objectManager.speed*objectManager.hugeTime, 0) duration:objectManager.hugeTime];
        [flObj runAction:move withKey:@"floating"];
    } else {
        objectManager.floatHit = NO;
    }
}

-(void) showLose {
    playerManager.moveable = NO;
    [playerManager.character removeAllActions];
    [playerManager.character runAction: playerManager.deadAnimation completion:^{
        SKCameraNode *camera = (SKCameraNode *)[scene childNodeWithName:@"mainCamera"];
        SKScene *s = [SKScene nodeWithFileNamed:@"LevelLost"];
        for (SKNode *node in s.children) {
            node.position = CGPointMake(camera.position.x + node.position.x, camera.position.y + node.position.y);
            [scene addChild:node.copy];
        }
    }];
}

-(void) showWin {
    playerManager.moveable = NO;
    [playerManager.character removeAllActions];
    [playerManager.character runAction: [SKAction fadeOutWithDuration:0.5] completion:^{
        SKCameraNode *camera = (SKCameraNode *)[scene childNodeWithName:@"mainCamera"];
        SKScene *s = [SKScene nodeWithFileNamed:@"LevelWon"];
        for (SKNode *node in s.children) {
            node.position = CGPointMake(camera.position.x + node.position.x, camera.position.y + node.position.y);
            [scene addChild:node.copy];
        }
        int levelNumber = [[scene.name stringByReplacingOccurrencesOfString:@"Level" withString:@""] intValue];
        __block int coinCount = 0;
        __block int coinCollected = 0;
        [scene enumerateChildNodesWithName:@"small-coin" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
            coinCount++;
            if (node.zPosition == 0)
                coinCollected++;
        }];
        
        __block int zombieCount = 0;
        __block int zombieKilled = 0;
        [scene enumerateChildNodesWithName:@"zombie" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
            zombieCount++;
            if (node.zPosition == 0)
                zombieKilled++;
        }];
        [dataLevelManager saveLevel:levelNumber withZombiesAvail:zombieCount withZombiesColl:zombieKilled withCoinsAvail:coinCount withCoinsColl:coinCollected];
        SKLabelNode *coins = (SKLabelNode *)[scene childNodeWithName:@"totalCoins"];
        [coins setText:[NSString stringWithFormat:@"%04d", [dataLevelManager getTotalCoinCount]]];
        SKLabelNode *zombies = (SKLabelNode *)[scene childNodeWithName:@"totalZombies"];
        [zombies setText:[NSString stringWithFormat:@"%04d", [dataLevelManager getTotalZombieCount]]];
        NSArray *array = [achievementMananger checkForAchievementsWithLevel:levelNumber withCoinTotal:coinCount withCoinsCollected:coinCollected withZombieTotal:zombieCount withZombiesKilled:zombieKilled];
        int i = 0;
        for (id object in array) {
            i++;
            //int index = (int)[object index];
            int num = [object intValue];
            SKSpriteNode *temp = (SKSpriteNode *)[scene childNodeWithName:[NSString stringWithFormat:@"Award%d", i]];
            [temp setTexture:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"flat_medal%d", num]]];
            [temp setHidden:NO];
            [dataAchievementManager saveAchievement:num];
        }
    }];
}

@end

