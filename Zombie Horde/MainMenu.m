//
//  MainMenu.m
//  Zombie Horde
//
//  Created by David Jefferies on 8/03/17.
//  Copyright © 2017 David Jefferies. All rights reserved.
//

#import "MainMenu.h"
#import "LevelClass.h"
#import "Sound.h"
#import "Data-Level.h"
#import "Achievements.h"
#import "Preferences.h"
#import "About.h"

@implementation MainMenu {
    SKLabelNode *_labelAbout;
    SKLabelNode *_labelPlay;
    SKLabelNode *_labelPreferences;
    SKLabelNode *_labelAchievements;
    
    Sound *soundManager;
    Data_Level *dataLevelManager;
}

//MyManager *sManager;

- (void)sceneDidLoad {
    soundManager = [Sound soundManager];
    dataLevelManager = [Data_Level dataLevelManager];
    [soundManager play:@"Intro Theme" withType:@"mp3"];
    _labelAbout = (SKLabelNode *)[self childNodeWithName:@"//btnAbout"];
    _labelPlay = (SKLabelNode *)[self childNodeWithName:@"//btnPlay"];
    _labelPreferences = (SKLabelNode *)[self childNodeWithName:@"//btnPreferences"];
    _labelAchievements = (SKLabelNode *)[self childNodeWithName:@"//btnAchievements"];
}

- (void)displayGame {
    int i = [dataLevelManager levelCount] + 1;
    [soundManager stop];
    [self removeActionForKey:@"backgroundAudio"];
    SKView *skView = (SKView *)self.view;
    [self removeFromParent];
    GKScene *scene = [GKScene sceneWithFileNamed:[NSString stringWithFormat:@"Level%d", i]];
    LevelClass *sceneNode = (LevelClass *)scene.rootNode;
    sceneNode.scaleMode = SKSceneScaleModeAspectFit;
    [skView presentScene:sceneNode];
}

- (void)displayAbout {
    SKView *skView = (SKView *)self.view;
    [self removeFromParent];
    GKScene *scene = [GKScene sceneWithFileNamed:@"About"];
    About *sceneNode = (About *)scene.rootNode;
    sceneNode.scaleMode = SKSceneScaleModeAspectFit;
    [skView presentScene:sceneNode];
}

- (void)displayPreferences {
    SKView *skView = (SKView *)self.view;
    [self removeFromParent];
    GKScene *scene = [GKScene sceneWithFileNamed:@"Preferences"];
    Preferences *sceneNode = (Preferences *)scene.rootNode;
    sceneNode.scaleMode = SKSceneScaleModeAspectFit;
    [skView presentScene:sceneNode];
}

- (void)displayAchievements {
    SKView *skView = (SKView *)self.view;
    [self removeFromParent];
    GKScene *scene = [GKScene sceneWithFileNamed:@"Achievements"];
    Achievements *sceneNode = (Achievements *)scene.rootNode;
    sceneNode.scaleMode = SKSceneScaleModeAspectFit;
    [skView presentScene:sceneNode];
}

- (void)touchUpAtPoint:(CGPoint)pos {
    if ([_labelAbout containsPoint:pos]) {
        [self displayAbout];
    } else if ([_labelPlay containsPoint:pos]) {
        [self displayGame];
    } else if ([_labelPreferences containsPoint:pos]) {
        [self displayPreferences];
    } else if ([_labelAchievements containsPoint:pos]) {
        [self displayAchievements];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
}

-(void)update:(CFTimeInterval)currentTime {
    
}

@end
