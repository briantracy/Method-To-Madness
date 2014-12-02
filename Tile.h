//
//  Tile.h
//  Method To Madness
//
//  Created by Brian Tracy on 9/13/14.
//  Copyright (c) 2014 Brian Tracy. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface Tile : NSObject

+(int)randomValue:(int)min to:(int)max; //returns random value in a specified range

@property int64_t val;
@property BOOL enabled;

@end