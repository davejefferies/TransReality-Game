//
//  AppDelegate.h
//  Zombie Horde
//
//  Created by David Jefferies on 8/03/17.
//  Copyright © 2017 David Jefferies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;

@end

