//
//  GameViewController.m
//  Zombie Horde
//
//  Created by David Jefferies on 8/03/17.
//  Copyright © 2017 David Jefferies. All rights reserved.
//

#import "GameViewController.h"
#import "MainMenu.h"

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
    // including entities and graphs.
    GKScene *scene = [GKScene sceneWithFileNamed:@"MainMenu"];
    
    // Get the SKScene from the loaded GKScene
    MainMenu *sceneNode = (MainMenu *)scene.rootNode;
    
    // Copy gameplay related content over to the scene
    //sceneNode.entities = [scene.entities mutableCopy];
    //sceneNode.graphs = [scene.graphs mutableCopy];
    
    // Set the scale mode to scale to fit the window
    sceneNode.scaleMode = SKSceneScaleModeAspectFill;
    
    SKView *skView = (SKView *)self.view;
    
    // Present the scene
    [skView presentScene:sceneNode];
    
    //skView.showsFPS = YES;
    //skView.showsNodeCount = YES;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
