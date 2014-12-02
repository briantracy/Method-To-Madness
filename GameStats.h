//
//  GameStats.h
//  Method To Madness
//
//  Created by Brian Tracy on 9/14/14.
//  Copyright (c) 2014 Brian Tracy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameStats : NSObject


@property (nonatomic) int64_t score;
@property (nonatomic) int moves;

- (void)writeToFile;
- (void)show;

+ (int64_t)highestScore;
+ (int)gamesPlayed;

@end
