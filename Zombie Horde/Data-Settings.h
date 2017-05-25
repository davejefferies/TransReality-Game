//
//  Data-Settings.h
//  Zombie Horde
//
//  Created by David Jefferies on 19/03/17.
//  Copyright © 2017 David Jefferies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "AppDelegate.h"

@interface Data_Settings : NSObject <NSFetchedResultsControllerDelegate> {
    NSManagedObjectContext *myContext;
    NSFetchedResultsController *resultsController;
    
    bool musicSetting;
    bool soundSetting;
}

@property (nonatomic) NSManagedObjectContext *myContext;
@property (nonatomic) NSFetchedResultsController *resultsController;

@property (nonatomic) bool musicSetting;
@property (nonatomic) bool soundSetting;

+ (id)dataSettingsManager;

-(void) saveSettingsWithMusic:(bool)music withSound:(bool)sound;
-(void) reset;

@end
