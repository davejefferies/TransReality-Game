//
//  LevelClass.h
//  Zombie Horde
//
//  Created by David Jefferies on 15/03/17.
//  Copyright © 2017 David Jefferies. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <GameplayKit/GameplayKit.h>

@interface LevelClass : SKScene  <SKPhysicsContactDelegate> {
    int *coinCount;
    int *zombieCount;
}

@property (nonatomic) int *coinCount;
@property (nonatomic) int *zombieCount;

@end
