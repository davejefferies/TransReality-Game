//
//  Sound.m
//  Zombie Horde
//
//  Created by David Jefferies on 12/03/17.
//  Copyright © 2017 David Jefferies. All rights reserved.
//

//
//  Object.m
//  Zombie Horde
//
//  Created by David Jefferies on 12/03/17.
//  Copyright © 2017 David Jefferies. All rights reserved.
//

#import "Sound.h"
#import "Data-Settings.h"

@implementation Sound {
    Data_Settings *settingsManager;
}

@synthesize audioPlayer;
@synthesize isPlaying;

+ (id)soundManager {
    static Sound *mySoundManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mySoundManager = [[self alloc] init];
    });
    
    return mySoundManager;
}

- (id)init {
    if (self = [super init]) {
        settingsManager = [Data_Settings dataSettingsManager];
        self.isPlaying = NO;
    }
    
    return self;
}

- (void)dealloc {
    //Should never be called
}

- (void)play:(NSString *)resource withType:(NSString *)type {
    if (settingsManager.musicSetting && !self.isPlaying) {
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:resource ofType:type];
        NSURL *url = [NSURL fileURLWithPath:soundPath];
        NSError *error;
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        self.audioPlayer.numberOfLoops = -1;
        [self.audioPlayer play];
        self.isPlaying = YES;
    }
}

- (void)stop {
    [self.audioPlayer stop];
    self.isPlaying = NO;
}

- (void)playEffect:(NSString *)effect withSelf:(SKNode *)this {
    if (settingsManager.soundSetting) {
        SKAction *audio = [SKAction playSoundFileNamed:effect waitForCompletion:NO];
        [this runAction:audio];
    }
}

@end

