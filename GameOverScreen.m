//
//  GameOverScreen.m
//  Method To Madness
//
//  Created by Brian Tracy on 9/14/14.
//  Copyright (c) 2014 Brian Tracy. All rights reserved.
//

#import "GameOverScreen.h"
#import "GraphicsHeader.h"

@implementation GameOverScreen

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (instancetype)initWithTitle:(NSString *)title
                 divideByZero:(BOOL)divideByZero
                    highScore:(BOOL)highScore
{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, 200, 200);
    }
    return self;
}
@end
