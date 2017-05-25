//
//  Data-Achievement.m
//  Zombie Horde
//
//  Created by David Jefferies on 17/03/17.
//  Copyright © 2017 David Jefferies. All rights reserved.
//

#import "Data-Achievement.h"

@implementation Data_Achievement {
    
}

@synthesize myContext;
@synthesize resultsController;

+ (id)dataAchievementManager {
    static Data_Achievement *myDataAchievementManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myDataAchievementManager = [[self alloc] init];
    });
    
    return myDataAchievementManager;
}

- (id)init {
    if (self = [super init]) {
        self.myContext = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.entity = [NSEntityDescription entityForName:@"Achievement" inManagedObjectContext:self.myContext];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
        fetchRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES]];
        self.resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.myContext sectionNameKeyPath:nil cacheName:nil];
        self.resultsController.delegate = (id)self;
        NSError *err;
        BOOL fetchSuccess = [self.resultsController performFetch:&err];
        if (!fetchSuccess) {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Couldn't Fetch" userInfo:nil];
        } else {
            NSLog(@"Fetch Successful");
        }
    }
    
    return self;
}

- (void)dealloc {
    //Should never be called
}

-(void) saveAchievement:(int)number {
    NSManagedObject *newAchievement;
    newAchievement = [NSEntityDescription insertNewObjectForEntityForName:@"Achievement" inManagedObjectContext:self.myContext];
    [newAchievement setValue:[NSNumber numberWithInteger:number] forKey:@"id"];
    NSError *error;
    [self.myContext save:&error];
}

-(NSArray *) getDistinctAchievements {
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Achievement" inManagedObjectContext:self.myContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    [request setReturnsDistinctResults:YES];
    
    NSError *error;
    NSArray *objects = [self.myContext executeFetchRequest:request error:&error];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSManagedObject *item in objects) {
        [array addObject:[item valueForKey:@"id"]];
    }
    
    return array;
}

-(void) reset {
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Achievement" inManagedObjectContext:self.myContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSError *error;
    NSArray *objects = [self.myContext executeFetchRequest:request error:&error];
    for (NSManagedObject *item in objects) {
        [self.myContext deleteObject:item];
    }
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
