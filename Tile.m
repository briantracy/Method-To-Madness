//
//  Tile.m
//  Method To Madness
//
//  Created by Brian Tracy on 9/13/14.
//  Copyright (c) 2014 Brian Tracy. All rights reserved.
//

#import "Tile.h"

@implementation Tile

-(instancetype)init {
    self = [super init];
    if (self) {
        self.enabled = YES;
    }
    return self;
}

+(int)randomValue:(int)min to: (int)max {
    return ( (arc4random() % (max-min+1)) + min );
}

@end
