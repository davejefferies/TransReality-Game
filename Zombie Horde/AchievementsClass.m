//
//  AchievementsClass.m
//  Zombie Horde
//
//  Created by David Jefferies on 17/03/17.
//  Copyright © 2017 David Jefferies. All rights reserved.
//

#import "AchievementsClass.h"

@implementation AchievementsClass {
    
}

+ (id)achievementsManager {
    static AchievementsClass *myAchievementsManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myAchievementsManager = [[self alloc] init];
    });
    
    return myAchievementsManager;
}

- (id)init {
    if (self = [super init]) {
    }
    
    return self;
}

- (void)dealloc {
    //Should never be called
}

-(NSMutableArray *) checkForAchievementsWithLevel:(int)level withCoinTotal:(int)coinTotal withCoinsCollected:(int)coinsCollected withZombieTotal:(int)zombieTotal withZombiesKilled:(int)zombiesKilled {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if (level == 1)
        [array addObject:[NSNumber numberWithInt:1]];
    else if (level == 5)
        [array addObject:[NSNumber numberWithInt:2]];
    else if (level == 10)
        [array addObject:[NSNumber numberWithInt:3]];
    else if (level == 15)
        [array addObject:[NSNumber numberWithInt:4]];
    else if (level == 20)
        [array addObject:[NSNumber numberWithInt:5]];
    else if (level == 25)
        [array addObject:[NSNumber numberWithInt:6]];
    
    if (coinTotal == coinsCollected)
        [array addObject:[NSNumber numberWithInt:7]];
    if (zombieTotal == zombiesKilled)
        [array addObject:[NSNumber numberWithInt:8]];
    
    return array;
}

@end
