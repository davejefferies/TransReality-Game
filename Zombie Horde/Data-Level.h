//
//  Data-Level.h
//  Zombie Horde
//
//  Created by David Jefferies on 15/03/17.
//  Copyright © 2017 David Jefferies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "AppDelegate.h"

@interface Data_Level : NSObject <NSFetchedResultsControllerDelegate> {
    NSManagedObjectContext *myContext;
    NSFetchedResultsController *resultsController;
}

@property (nonatomic) NSManagedObjectContext *myContext;
@property (nonatomic) NSFetchedResultsController *resultsController;

+ (id)dataLevelManager;

-(void) saveLevel:(int)number withZombiesAvail:(int)zombiesAvail withZombiesColl:(int)zombiesColl withCoinsAvail:(int)coinsAvail withCoinsColl:(int)coinsColl;

-(int) levelCount;

-(int) getTotalCoinCount;
-(int) getTotalZombieCount;
-(void) reset;

@end
