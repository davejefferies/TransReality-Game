//
//  Data-Level.m
//  Zombie Horde
//
//  Created by David Jefferies on 15/03/17.
//  Copyright © 2017 David Jefferies. All rights reserved.
//

#import "Data-Level.h"

@implementation Data_Level {
    
}

@synthesize myContext;
@synthesize resultsController;

+ (id)dataLevelManager {
    static Data_Level *myDataLevelManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myDataLevelManager = [[self alloc] init];
    });
    
    return myDataLevelManager;
}

- (id)init {
    if (self = [super init]) {
        self.myContext = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.entity = [NSEntityDescription entityForName:@"Level" inManagedObjectContext:self.myContext];
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

-(void) saveLevel:(int)number withZombiesAvail:(int)zombiesAvail withZombiesColl:(int)zombiesColl withCoinsAvail:(int)coinsAvail withCoinsColl:(int)coinsColl {
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObject *newLevel;
    newLevel = [NSEntityDescription insertNewObjectForEntityForName:@"Level" inManagedObjectContext:self.myContext];
    [newLevel setValue:[NSNumber numberWithInteger:number] forKey:@"id"];
    [newLevel setValue:[NSNumber numberWithInteger:zombiesAvail] forKey:@"zombies_available"];
    [newLevel setValue:[NSNumber numberWithInteger:zombiesColl] forKey:@"zombies_killed"];
    [newLevel setValue:[NSNumber numberWithInteger:coinsAvail] forKey:@"coins_available"];
    [newLevel setValue:[NSNumber numberWithInteger:coinsColl] forKey:@"coins_collected"];
    NSError *error;
    [self.myContext save:&error];
}

-(int) levelCount {
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Level" inManagedObjectContext:self.myContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSError *error;
    NSArray *objects = [self.myContext executeFetchRequest:request error:&error];
    
    return (int)[objects count];
}

-(int) getTotalCoinCount {
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Level" inManagedObjectContext:self.myContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSError *error;
    NSArray *objects = [self.myContext executeFetchRequest:request error:&error];
    int cnt = 0;
    for (NSManagedObject *item in objects) {
        cnt += [[item valueForKey:@"coins_collected"] intValue];
    }
    
    return cnt;
}

-(int) getTotalZombieCount {
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Level" inManagedObjectContext:self.myContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSError *error;
    NSArray *objects = [self.myContext executeFetchRequest:request error:&error];
    int cnt = 0;
    for (NSManagedObject *item in objects) {
        cnt += [[item valueForKey:@"zombies_killed"] intValue];
    }
    
    return cnt;
}

-(void) reset {
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Level" inManagedObjectContext:self.myContext];
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
