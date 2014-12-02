//
//  NSArray+Helpers.m
//  Method To Madness
//
//  Created by Brian Tracy on 9/13/14.
//  Copyright (c) 2014 Brian Tracy. All rights reserved.
//

#import "NSArray+Helpers.h"

@implementation NSArray (Helpers)

- (NSArray *) shuffled
{
	// create temporary autoreleased mutable array
	NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:self];
    
	for (NSUInteger i = [self count]-1; i>=1; i--) {
        u_int32_t j = arc4random_uniform((int) i+1);
        [tmpArray exchangeObjectAtIndex:i withObjectAtIndex:j];
    }
    
	return [NSArray arrayWithArray:tmpArray];  // non-mutable autoreleased copy
}

@end