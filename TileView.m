//
//  TileView.m
//  Method To Madness
//
//  Created by Brian Tracy on 9/13/14.
//  Copyright (c) 2014 Brian Tracy. All rights reserved.
//

#import "TileView.h"

@implementation TileView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setOpaque:NO];
        [self setBackgroundColor:[UIColor colorWithRed:255/255 green:102.0/255 blue:(102.0+0)/255 alpha:1.0]];
        
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        
        int border = 10;
        CGRect newFrame = CGRectMake(border, border, self.bounds.size.width-border*2, self.bounds.size.height-border*2);
        self.label = [[UILabel alloc] initWithFrame: newFrame];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self.label setAdjustsFontSizeToFitWidth:YES];
        
        [super addSubview:self.label];
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    self.label.text = [NSString stringWithFormat:@"%lld", self.val];
}





@end

