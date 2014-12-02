//
//  HelperArray.h
//  Method To Madness
//
//  Created by Brian Tracy on 9/13/14.
//  Copyright (c) 2014 Brian Tracy. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Tile.h"

typedef enum {
    Up = 0,
    Down,
    Left,
    Right,
    None
} Direction;

typedef struct _OrderedPair {
    int x, y;
} OrderedPair;

@interface HelperArray : NSObject

@property (nonatomic) int dimension;
@property (nonatomic) NSMutableArray *backingStore;

- (instancetype)initWithDimension:(int)size;
- (id)objectAtIndex:(OrderedPair)idx;
- (void)setObject:(id)object atIndex:(OrderedPair)idx;
- (void)addObject:(id)object;
- (NSUInteger)refinedIndexForOrderedPair:(OrderedPair)idx;
- (id)objectAtLinearIndex:(int)index;
- (id)objectAtIndex:(int)x by:(int)y;

@end