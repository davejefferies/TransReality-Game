//
//  Sound.h
//  Zombie Horde
//
//  Created by David Jefferies on 12/03/17.
//  Copyright © 2017 David Jefferies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import <GameplayKit/GameplayKit.h>
#import <AVFoundation/AVFoundation.h>

@interface Sound : NSObject {
    AVAudioPlayer *audioPlayer;
    bool isPlaying;
}

@property (nonatomic) AVAudioPlayer *audioPlayer;
@property (nonatomic) bool isPlaying;

+ (id)soundManager;

- (void)play:(NSString *)resource withType:(NSString *)type;
- (void)playEffect:(NSString *)effect withSelf:(SKNode *)type;
- (void)stop;

@end
