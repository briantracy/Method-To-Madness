//
//  Game.m
//  Method To Madness
//
//  Created by Brian Tracy on 9/13/14.
//  Copyright (c) 2014 Brian Tracy. All rights reserved.
//

#import "Game.h"

@implementation Game
NSDictionary *gameAttributes;

-(instancetype)init {
    self = [super init];
    if (self) {
        ActiveTileArrayKey = @"active";
        SwipeDirectionKey = @"swipe";
        OperatorStackKey = @"operate";
        FocusTileInfoKey = @"focus";
        InitialOperatorStackKey = @"ioperate";
        InitialTileArrayKey = @"ivalues";
        GameStateInGameKey = @"gamestate";
    }
    return self;
}

-(BOOL)isOver {
    int numberOfActiveTiles = 0;
    for (int i = 0; i<self.tileArray.dimension; i++) {
        for (int j = 0; j<self.tileArray.dimension; j++) {
            if ([[self.tileArray objectAtIndex:i by:j] enabled]) {
                numberOfActiveTiles++;
            }
        }
    }
    //handles /0 case
    if (numberOfActiveTiles == 0) {
        return YES;
    }
    //handles regular gameIsOver case
    if (numberOfActiveTiles == 1 && [[self.tileArray objectAtIndex:self.focusTileCoordinates.x by:self.focusTileCoordinates.y] enabled]) {
        return YES;
    }
    
    return NO;
}

-(NSArray *)parseDataFromArrayWithTarget:(NSString *) property{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int x = 0; x<self.tileArray.dimension; x++) {
        for (int y = 0; y<self.tileArray.dimension; y++) {
            OrderedPair pair = {x,y};
            if ([property isEqualToString:@"value"]) {
                [array addObject:@([(Tile *)[self.tileArray objectAtIndex:pair] val])];
            }
            if ([property isEqualToString:@"enabled"]) {
                [array addObject:[NSNumber numberWithBool:[(Tile *)[self.tileArray objectAtIndex:pair] enabled]]];
            }
        }
    }
    return array;
}

-(NSString *)newOperator {
    return [@[@"+",@"−",@"\u00D7",@"÷"] objectAtIndex:arc4random_uniform(4)];
}

-(void)newGameWithGameAttributes: (NSDictionary *) attributes {
    gameAttributes = attributes;
    int gridSize = [[gameAttributes objectForKey:@"GridSize"] intValue];
    int numberOfOperators = [[gameAttributes objectForKey:@"OperatorSize"] intValue];
    self.gameStats = [[GameStats alloc] init];
    NSMutableArray *flexibleArray = [[NSMutableArray alloc] init];
    
    //create initial array with random operators
    for (int i = 0; i<numberOfOperators; i++) {
        [flexibleArray addObject:[self newOperator]];
    }
    self.operatorArray = [[NSArray alloc] initWithArray:flexibleArray];
    
    //create initial array with tiles
    self.tileArray = [[HelperArray alloc] initWithDimension:gridSize];
    for (int x = 0; x<gridSize; x++) {
        for (int y = 0; y<gridSize; y++) {
            Tile *tile = [[Tile alloc] init];
            [self.tileArray addObject:tile];
        }
    }
    
    NSMutableArray *temporaryArray = [[NSMutableArray alloc] initWithCapacity:24];
    for (int i = 0; i<6; i++) {
        for (int j = 0; j<4; j++) {
            [temporaryArray addObject:[NSNumber numberWithInt:i]];
        }
    }
    
    NSArray *tileValArray = [temporaryArray shuffled];
    for (int i = 0; i<self.tileArray.backingStore.count-1; i++) {
        [[self.tileArray objectAtLinearIndex:i] setVal:[[tileValArray objectAtIndex:i] intValue]];
    }
    
    //initialize then randomize tile values
    
    OrderedPair pair = {(gridSize-1)/2, (gridSize-1)/2};
    self.focusTileCoordinates = pair;
    self.gameStats.score = [[self.tileArray objectAtIndex:(gridSize-1)/2 by:(gridSize-1)/2] val];
    
    NSDictionary *initialValues = @{
                                    InitialTileArrayKey : [self parseDataFromArrayWithTarget:@"value"],
                                    InitialOperatorStackKey : self.operatorArray,
                                    GameStateInGameKey : [NSNumber numberWithBool: NO]
                                    };
    [self.delegate setAttributes:initialValues];
}

-(void)moveBoardInDirection:(Direction)swipeDirection {
    if ([self canSwipeInDirection:swipeDirection]) {
        [self applyGameLogicWithDirection: swipeDirection];
    } else {
        swipeDirection = None;
    }
    NSNumber *scoreInfo = [NSNumber numberWithLongLong:self.gameStats.score];
    NSDictionary *attributes = @{
                                 ActiveTileArrayKey : [self parseDataFromArrayWithTarget:@"enabled"],
                                 OperatorStackKey : [self operatorArray],
                                 SwipeDirectionKey : [NSNumber numberWithInt:swipeDirection],
                                 FocusTileInfoKey : scoreInfo,
                                 GameStateInGameKey : [NSNumber numberWithBool: YES]
                                 };
    [self.delegate setAttributes: attributes];
}

-(void) applyGameLogicWithDirection:(Direction)direction {
    self.gameStats.moves++;
    int xdif = 0;
    int ydif = 0;
    if (direction == Up) {
        ydif++;
    }
    if (direction == Down) {
        ydif--;
    }
    if (direction == Left) {
        xdif++;
    }
    if (direction == Right) {
        xdif--;
    }
    [[self.tileArray objectAtIndex:self.focusTileCoordinates.x by:self.focusTileCoordinates.y] setEnabled:NO];
    if ([[self.tileArray objectAtIndex:self.focusTileCoordinates.x+xdif by:self.focusTileCoordinates.y+ydif] enabled]) {
        [self performOperation:[self.operatorArray objectAtIndex:0] onFocusTileWithValue:
         (int)[[self.tileArray objectAtIndex:self.focusTileCoordinates.y+ydif by:self.focusTileCoordinates.x+xdif] val]];
    }
    OrderedPair pair = {self.focusTileCoordinates.x+xdif,self.focusTileCoordinates.y+ydif};
    self.focusTileCoordinates = pair;
}

-(void)performOperation:(NSString *)operation onFocusTileWithValue:(int)value {
    if ([operation isEqualToString:@"+"]) {
        self.gameStats.score+=value;
    }
    if ([operation isEqualToString:@"−"]) {
        self.gameStats.score-=value;
    }
    if ([operation isEqualToString:@"\u00D7"]) {
        self.gameStats.score*=value;
    }
    if ([operation isEqualToString:@"÷"]) {
        if (value != 0) {
            self.gameStats.score/=value;
        } else {
            self.dividedByZero = YES;
            self.gameStats.score = 0;
            for (int i = 0; i<self.tileArray.dimension; i++) {
                for (int j = 0; j<self.tileArray.dimension; j++) {
                    [[self.tileArray objectAtIndex:i by:j] setEnabled:false];
                }
            }
        }
    }
    
    //updates operators
    NSMutableArray *newOperatorArray = [[NSMutableArray alloc] init];
    for (int i = 1; i<[[gameAttributes objectForKey:@"OperatorSize"] integerValue]; i++) {
        [newOperatorArray addObject:[self.operatorArray objectAtIndex:i]];
    }
    [newOperatorArray addObject:[self newOperator]];
    self.operatorArray = newOperatorArray;
    
}

-(BOOL) canSwipeInDirection:(Direction)direction {
    int dim = self.tileArray.dimension;
    if (direction == Up) {
        return!(self.focusTileCoordinates.y == dim-1);
    }
    if (direction == Down) {
        return!(self.focusTileCoordinates.y == 0);
    }
    if (direction == Left) {
        return!(self.focusTileCoordinates.x == dim-1);
    }
    if (direction == Right) {
        return!(self.focusTileCoordinates.x == 0);
    }
    return YES;
}

@end
