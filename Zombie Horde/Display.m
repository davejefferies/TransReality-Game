//
//  Display.m
//  Zombie Horde
//
//  Created by David Jefferies on 12/03/17.
//  Copyright © 2017 David Jefferies. All rights reserved.
//

#import "Display.h"
#import "Player.h"

@implementation Display {
    Player *playerManager;
    
    SKNode *background;
    SKScene *scene;
    SKNode *endPoint;
    SKNode *coinCount;
    SKNode *coinCountPic;
    SKCameraNode *camera;
    SKScene *hud;
}

+ (id)displayManager:(SKNode *)this {
    static Display *myDisplayManager = nil;
    //static dispatch_once_t onceToken;
    //dispatch_once(&onceToken, ^{
      myDisplayManager = [[self alloc] init:this];
    //});
    
    return myDisplayManager;
}

- (id)init:(SKNode *)this {
    scene = (SKScene *)this;
    playerManager = [Player playerManager];
    
    [self setupHeadsUpDisplay];
    
    coinCount = [scene childNodeWithName:@"coin-label"];
    coinCountPic = [scene childNodeWithName:@"coin"];
    
    background = [scene childNodeWithName:@"background"];
    playerManager.character = [scene childNodeWithName:@"character"];
    endPoint = [scene childNodeWithName:@"endPoint"];
    camera = (SKCameraNode *)[scene childNodeWithName:@"mainCamera"];
    playerManager.attackLeft = [scene childNodeWithName:@"attack-left"];
    playerManager.attackRight = [scene childNodeWithName:@"attack-right"];
    playerManager.speed = 200;
    playerManager.hugeTime = 9999.0;
    playerManager.moveable = YES;
    playerManager.leftTouch = NO;
    playerManager.rightTouch = NO;
    playerManager.attackTouch = NO;
    playerManager.attacking = NO;
    
    id horizConstraint = [SKConstraint distance:[SKRange rangeWithUpperLimit:100] toNode:playerManager.character];
    id vertConstraint = [SKConstraint distance:[SKRange rangeWithUpperLimit:50] toNode:playerManager.character];
    
    id leftConstraint = [SKConstraint positionX:[SKRange rangeWithLowerLimit:camera.position.x]];
    id rightConstraint = [SKConstraint positionX:[SKRange rangeWithUpperLimit:(endPoint.position.x-camera.position.x-(scene.frame.size.width/2) - 10)]];
    id topConstraint = [SKConstraint positionY:[SKRange rangeWithUpperLimit:(background.frame.size.height-camera.position.y)]];
    id bottomConstraint = [SKConstraint positionY:[SKRange rangeWithLowerLimit:camera.position.y]];
    
    [camera setConstraints:@[horizConstraint, vertConstraint, leftConstraint, bottomConstraint, rightConstraint, topConstraint]];
    
    return self;
}

- (void)dealloc {
    //Should never be called
}

-(void) setupHeadsUpDisplay {
    hud = [SKScene nodeWithFileNamed:@"HeadsUpDisplay"];
    for (SKNode *node in hud.children) {
        [scene addChild:node.copy];
    }
}

-(void) update {
    background.position = CGPointMake(camera.position.x, camera.position.y);
    playerManager.attackLeft.position = CGPointMake(camera.position.x - (scene.frame.size.width / 2) + (playerManager.attackLeft.frame.size.width / 2), camera.position.y - (scene.frame.size.height / 2) + (playerManager.attackLeft.frame.size.height / 2));
    playerManager.attackRight.position = CGPointMake(camera.position.x + (scene.frame.size.width / 2) - (playerManager.attackLeft.frame.size.width / 2), camera.position.y - (scene.frame.size.height / 2) + (playerManager.attackLeft.frame.size.height / 2));
    
    float xDiff = hud.frame.size.width - [hud childNodeWithName:@"coin-label"].position.x - (hud.frame.size.width / 2) - ([hud childNodeWithName:@"coin-label"].frame.size.width / 2);
    float yDiff = hud.frame.size.height - [hud childNodeWithName:@"coin-label"].position.y - (hud.frame.size.height / 2) - ([hud childNodeWithName:@"coin-label"].frame.size.height / 2);
    coinCount.position = CGPointMake(camera.position.x + (scene.frame.size.width / 2) - (coinCount.frame.size.width / 2) - xDiff, camera.position.y + (scene.frame.size.height / 2) - (coinCount.frame.size.height / 2) - yDiff);
    
    xDiff = hud.frame.size.width - [hud childNodeWithName:@"coin"].position.x - (hud.frame.size.width / 2) - ([hud childNodeWithName:@"coin"].frame.size.width / 2);
    yDiff = hud.frame.size.height - [hud childNodeWithName:@"coin"].position.y - (hud.frame.size.height / 2) - ([hud childNodeWithName:@"coin"].frame.size.height / 2);
    
    coinCountPic.position = CGPointMake(camera.position.x + (scene.frame.size.width / 2) - (coinCountPic.frame.size.width / 2) - xDiff, camera.position.y + (scene.frame.size.height / 2) - (coinCountPic.frame.size.height / 2) - yDiff);
}

@end

