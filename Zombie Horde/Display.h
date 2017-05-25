//
//  Display.h
//  Zombie Horde
//
//  Created by David Jefferies on 12/03/17.
//  Copyright © 2017 David Jefferies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface Display : NSObject {
}

+ (id)displayManager:(SKNode *)this;

-(void) update;

@end
