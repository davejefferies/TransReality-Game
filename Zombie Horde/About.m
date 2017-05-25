//
//  About.m
//  Zombie Horde
//
//  Created by David Jefferies on 19/03/17.
//  Copyright © 2017 David Jefferies. All rights reserved.
//

#import "About.h"
#import "MainMenu.h"

@implementation About

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

@end
