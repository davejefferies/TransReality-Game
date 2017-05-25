//
//  Data-Achievement.h
//  Zombie Horde
//
//  Created by David Jefferies on 17/03/17.
//  Copyright © 2017 David Jefferies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "AppDelegate.h"

@interface Data_Achievement : NSObject <NSFetchedResultsControllerDelegate> {
    NSManagedObjectContext *myContext;
    NSFetchedResultsController *resultsController;
}

@property (nonatomic) NSManagedObjectContext *myContext;
@property (nonatomic) NSFetchedResultsController *resultsController;

+ (id)dataAchievementManager;

-(void) saveAchievement:(int)number;

-(void) reset;

-(NSArray *) getDistinctAchievements;

@end
