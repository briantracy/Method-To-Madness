//
//  HelperArray.m
//  Method To Madness
//
//  Created by Brian Tracy on 9/13/14.
//  Copyright (c) 2014 Brian Tracy. All rights reserved.
//

#import "HelperArray.h"

@interface HelperArray ()

@end

@implementation HelperArray

- (instancetype)initWithDimension:(int)dim
{
    if (self = [super init]) {
        self.dimension = dim;
        NSUInteger refinedDimension = dim * dim;
        
        self.backingStore = [[NSMutableArray alloc] initWithCapacity:refinedDimension];
    }
    return self;
}

- (id)objectAtIndex:(OrderedPair)idx
{
    return [self.backingStore objectAtIndex:[self refinedIndexForOrderedPair:idx]];
}

- (void)setObject:(id)object atIndex:(OrderedPair)idx
{
    NSUInteger refinedIndex = [self refinedIndexForOrderedPair:idx];
    
    [self.backingStore removeObjectAtIndex:refinedIndex];
    
    [self.backingStore insertObject:object atIndex:refinedIndex];
}

- (NSUInteger)refinedIndexForOrderedPair:(OrderedPair)idx
{
    NSUInteger refinedIndex = ((idx.x * self.dimension) + idx.y);
    
    return refinedIndex;
}

- (id)objectAtIndex:(int)x by:(int)y
{
    int refinedIndex = ((x * self.dimension) + y);
    return [self.backingStore objectAtIndex:refinedIndex];
}

- (id)objectAtLinearIndex:(int)index
{
    return [self.backingStore objectAtIndex:index];
}

- (void)addObject:(id)object {
    [self.backingStore addObject: object];
}

@end
