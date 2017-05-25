//
//  Collision.h
//  Zombie Horde
//
//  Created by David Jefferies on 12/03/17.
//  Copyright © 2017 David Jefferies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface Collision : NSObject {
}

+ (id)collisionManager:(SKNode *)this;

- (void)beganContact:(SKPhysicsContact *)contact withSelf:(SKNode *)this;

-(void) touchEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event withSelf:(SKNode *)this;

-(void) update;

@end
