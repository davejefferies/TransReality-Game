//
//  Data-Settings.m
//  Zombie Horde
//
//  Created by David Jefferies on 19/03/17.
//  Copyright © 2017 David Jefferies. All rights reserved.
//

#import "Data-Settings.h"

@implementation Data_Settings {
    
}

@synthesize myContext;
@synthesize resultsController;
@synthesize musicSetting;
@synthesize soundSetting;

+ (id)dataSettingsManager {
    static Data_Settings *myDataSettingsManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myDataSettingsManager = [[self alloc] init];
    });
    
    return myDataSettingsManager;
}

- (id)init {
    if (self = [super init]) {
        self.myContext = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.entity = [NSEntityDescription entityForName:@"Settings" inManagedObjectContext:self.myContext];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
        fetchRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"music" ascending:YES]];
        self.resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.myContext sectionNameKeyPath:nil cacheName:nil];
        self.resultsController.delegate = (id)self;
        NSError *err;
        BOOL fetchSuccess = [self.resultsController performFetch:&err];
        if (!fetchSuccess) {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Couldn't Fetch" userInfo:nil];
        } else {
            NSLog(@"Fetch Successful");
            [self loadSettings];
        }
    }
    
    return self;
}

- (void)dealloc {
    //Should never be called
}

-(void) loadSettings {
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Settings" inManagedObjectContext:self.myContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSError *error;
    NSArray *objects = [self.myContext executeFetchRequest:request error:&error];
    if ([objects count] == 0) {
        self.musicSetting = YES;
        self.soundSetting = YES;
        NSManagedObject *newSetting = [NSEntityDescription insertNewObjectForEntityForName:@"Settings" inManagedObjectContext:self.myContext];
        [newSetting setValue:@YES forKey:@"music"];
        [newSetting setValue:@YES forKey:@"sound"];
        NSError *err;
        [self.myContext save:&err];
    } else {
        NSManagedObject *item = objects[0];
        self.musicSetting = [[item valueForKey:@"music"] boolValue];
        self.soundSetting = [[item valueForKey:@"sound"] boolValue];
    }
}

-(void) saveSettingsWithMusic:(bool)music withSound:(bool)sound {
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Settings" inManagedObjectContext:self.myContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSError *error;
    NSArray *objects = [self.myContext executeFetchRequest:request error:&error];
    for (NSManagedObject *object in objects) {
        [self.myContext deleteObject:object];
    }
    
    NSManagedObject *newSetting = [NSEntityDescription insertNewObjectForEntityForName:@"Settings" inManagedObjectContext:self.myContext];
    [newSetting setValue:[NSNumber numberWithBool:music] forKey:@"music"];
    [newSetting setValue:[NSNumber numberWithBool:sound] forKey:@"sound"];
    NSError *err;
    [self.myContext save:&err];
    self.musicSetting = music;
    self.soundSetting = sound;
    
}

-(void) reset {
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Settings" inManagedObjectContext:self.myContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSError *error;
    NSArray *objects = [self.myContext executeFetchRequest:request error:&error];
    for (NSManagedObject *object in objects) {
        [self.myContext deleteObject:object];
    }
    self.musicSetting = YES;
    self.soundSetting = YES;
}

#pragma - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    //[self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
}

- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller {
    //[self.tableView endUpdates];
}

@end
