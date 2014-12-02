//
//  GameStats.m
//  Method To Madness
//
//  Created by Brian Tracy on 9/14/14.
//  Copyright (c) 2014 Brian Tracy. All rights reserved.
//

#import "GameStats.h"

@implementation GameStats

- (instancetype)init
{
    if (self = [super init]) {
        self.moves = 0;
        self.score = 0;
    }
    return self;
}

- (void)writeToFile
{
    NSString * highScoreKey    = @"highScore";
    NSString * gamesPlayedKey  = @"gamesPlayed";
    
    
    // HIGH SCORE
    if (self.score > [[GameStats safeGet:highScoreKey] longLongValue]) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithLongLong:self.score] forKey:highScoreKey];
    }
    else {
        // NOT THE HIGHEST SCOREL, BUT MAYBE IN THE TOP TEN
        
        
        
        
        
    }
    
    
    // GAMES PLAYED
    NSNumber * gamesPlayed = @([[GameStats safeGet:gamesPlayedKey] intValue] + 1);
    [[NSUserDefaults standardUserDefaults] setObject:gamesPlayed forKey:gamesPlayedKey];
    
    

    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)show
{
    //NSLog(@"games played = %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"gamesPlayed"]);
}

+ (NSNumber *)safeGet:(NSString *)key
{
    NSNumber * num = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return num ? num : @0;
}

- (void)clear
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}


+ (int)gamesPlayed
{
    return [[self safeGet:@"gamesPlayed"] intValue];
}

+ (int64_t)highestScore
{
    return [[self safeGet:@"highScore"] longLongValue];
}

@end
