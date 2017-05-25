//
//  AchievementsClass.h
//  Zombie Horde
//
//  Created by David Jefferies on 17/03/17.
//  Copyright © 2017 David Jefferies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface AchievementsClass : NSObject {
    
}

+ (id)achievementsManager;

-(NSArray *) checkForAchievementsWithLevel:(int)level withCoinTotal:(int)coinTotal withCoinsCollected:(int)coinsCollected withZombieTotal:(int)zombieTotal withZombiesKilled:(int)zombiesKilled;

@end
