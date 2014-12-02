//
//  Game.h
//  Method To Madness
//
//  Created by Brian Tracy on 9/13/14.
//  Copyright (c) 2014 Brian Tracy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameStats.h"
#import "Tile.h"
#import "HelperArray.h"
#import "GameData.h"
#import "NSArray+Helpers.h"

@interface Game : NSObject
@property (nonatomic) HelperArray *tileArray;
@property (nonatomic) NSArray *operatorArray;
@property (nonatomic) GameStats *gameStats;
@property (nonatomic, strong) id<GameData> delegate;
@property (nonatomic) OrderedPair focusTileCoordinates;

-(void)newGameWithGameAttributes:(NSDictionary *)gameAttributes;
-(void)moveBoardInDirection:(Direction)swipeDirection;
-(NSArray *)parseDataFromArrayWithTarget:(NSString *)property;
-(BOOL)isOver;

@property (nonatomic) BOOL dividedByZero;

@end