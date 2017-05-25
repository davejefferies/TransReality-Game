//
//  Achievements.m
//  Zombie Horde
//
//  Created by David Jefferies on 17/03/17.
//  Copyright © 2017 David Jefferies. All rights reserved.
//

#import "Achievements.h"
#import "Data-Achievement.h"
#import "MainMenu.h"

@implementation Achievements {
    Data_Achievement *dataManager;
}

- (void)didMoveToView:(SKView *)view {
    dataManager = [Data_Achievement dataAchievementManager];
    [self setupAchievements];
}

-(void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    UITouch *aTouch = [touches anyObject];
    CGPoint newLocation = [aTouch locationInView:self.view];
    CGPoint prevLocation = [aTouch previousLocationInView:self.view];
    SKNode *left = [self childNodeWithName:@"leftSide"];
    SKNode *right = [self childNodeWithName:@"rightSide"];
    if (newLocation.x > prevLocation.x) {
        //finger went right
        CGFloat f = newLocation.x - prevLocation.x;
        for (SKNode *node in self.children) {
            if (![node.name isEqualToString:@"btnBack"] && ![node.name isEqualToString:@"title"] && left.position.x < -(self.size.width / 2))
                node.position = CGPointMake(node.position.x + f, node.position.y);
        }
    } else {
        //finger went left
        CGFloat f = prevLocation.x - newLocation.x;
        for (SKNode *node in self.children) {
            if (![node.name isEqualToString:@"btnBack"] && ![node.name isEqualToString:@"title"] && right.position.x > (self.size.width / 2))
                node.position = CGPointMake(node.position.x - f, node.position.y);
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {
        CGPoint pos = [t locationInNode:self];
        if ([[self childNodeWithName:@"btnBack"] containsPoint:pos]) {
            SKView *skView = (SKView *)self.view;
            [self removeFromParent];
            GKScene *scene = [GKScene sceneWithFileNamed:@"MainMenu"];
            MainMenu *sceneNode = (MainMenu *)scene.rootNode;
            sceneNode.scaleMode = SKSceneScaleModeAspectFit;
            [skView presentScene:sceneNode];
        }
    }
}

-(void) setupAchievements {
    NSArray *array = [dataManager getDistinctAchievements];
    for (id item in array) {
        int num = [item intValue];
        SKSpriteNode *temp = (SKSpriteNode *)[self childNodeWithName:[NSString stringWithFormat:@"medal%d", num]];
        [temp setTexture:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"flat_medal%d", num]]];
    }
}

@end
