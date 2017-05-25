//
//  Preferences.m
//  Zombie Horde
//
//  Created by David Jefferies on 19/03/17.
//  Copyright © 2017 David Jefferies. All rights reserved.
//

#import "Preferences.h"
#import "Data-Achievement.h"
#import "Data-Level.h"
#import "Data-Settings.h"
#import "Sound.h"
#import "MainMenu.h"

@implementation Preferences {
    Data_Level *levelManager;
    Data_Settings *settingsManager;
    Data_Achievement *achievementManager;
    Sound *soundManager;
}

- (void)didMoveToView:(SKView *)view {
    levelManager = [Data_Level dataLevelManager];
    settingsManager = [Data_Settings dataSettingsManager];
    achievementManager = [Data_Achievement dataAchievementManager];
    soundManager = [Sound soundManager];
    [self setup];
}

-(void) setup {
    if (settingsManager.musicSetting) {
        [self setSlider:@"music" withSetting:@"on"];
    } else {
        [self setSlider:@"music" withSetting:@"off"];
    }
    if (settingsManager.soundSetting) {
        [self setSlider:@"sound" withSetting:@"on"];
    } else {
        [self setSlider:@"sound" withSetting:@"off"];
    }
}

-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    SKNode *musicNode = [self childNodeWithName:@"musicSlider"];
    SKNode *soundNode = [self childNodeWithName:@"soundSlider"];
    SKNode *backNode = [self childNodeWithName:@"btnBack"];
    SKNode *resetNode = [self childNodeWithName:@"btnReset"];
    for (UITouch *t in touches) {
        if ([musicNode containsPoint:[t locationInNode:self]]) {
            if (settingsManager.musicSetting) {
                [self setSlider:@"music" withSetting:@"off"];
                [settingsManager saveSettingsWithMusic:NO withSound:settingsManager.soundSetting];
                [soundManager stop];
            } else {
                [self setSlider:@"music" withSetting:@"on"];
                [settingsManager saveSettingsWithMusic:YES withSound:settingsManager.soundSetting];
                [soundManager play:@"Intro Theme" withType:@"mp3"];
            }
        } else if ([soundNode containsPoint:[t locationInNode:self]]) {
            if (settingsManager.soundSetting) {
                [self setSlider:@"sound" withSetting:@"off"];
                [settingsManager saveSettingsWithMusic:settingsManager.musicSetting withSound:NO];
            } else {
                [self setSlider:@"sound" withSetting:@"on"];
                [settingsManager saveSettingsWithMusic:settingsManager.musicSetting withSound:YES];
            }
        } else if ([backNode containsPoint:[t locationInNode:self]]) {
            SKView *skView = (SKView *)self.view;
            [self removeFromParent];
            GKScene *scene = [GKScene sceneWithFileNamed:@"MainMenu"];
            MainMenu *sceneNode = (MainMenu *)scene.rootNode;
            sceneNode.scaleMode = SKSceneScaleModeAspectFit;
            [skView presentScene:sceneNode];
        } else if ([resetNode containsPoint:[t locationInNode:self]]) {
            [levelManager reset];
            [settingsManager reset];
            [achievementManager reset];
            SKView *skView = (SKView *)self.view;
            [self removeFromParent];
            GKScene *scene = [GKScene sceneWithFileNamed:@"MainMenu"];
            MainMenu *sceneNode = (MainMenu *)scene.rootNode;
            sceneNode.scaleMode = SKSceneScaleModeAspectFit;
            [skView presentScene:sceneNode];
        }
    }
}

-(void)setSlider:(NSString *)name withSetting:(NSString *)setting {
    SKSpriteNode *temp = (SKSpriteNode *)[self childNodeWithName:[NSString stringWithFormat:@"%@Slider", name]];
    [temp setTexture:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"element_toggle_%@", setting]]];
}

@end
