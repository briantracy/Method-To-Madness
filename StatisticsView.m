//
//  StatisticsView.m
//  Method To Madness
//
//  Created by Brian Tracy on 9/14/14.
//  Copyright (c) 2014 Brian Tracy. All rights reserved.
//

#import "StatisticsView.h"
#import "GameStats.h"
#import "GraphicsHeader.h"

@implementation StatisticsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.alpha = 0;
    }
    return self;
}


- (void)render
{
    for (UIView * sub in self.subviews) {
        [sub removeFromSuperview];
    }
    
    self.isShown = YES;
    
    [self showStats];
    [UIView animateWithDuration:.5 animations:^{
        self.layer.cornerRadius = 15;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor blackColor] CGColor];
        self.backgroundColor = [UIColor whiteColor];
        self.alpha = 1;
    }];
    
    
}

- (void)showStats
{
    CGFloat fontSize = 20;
    
    NSMutableAttributedString * highScore = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"High Score\n%lld\n", [GameStats highestScore]] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Courier New" size:fontSize]}];
    
    NSAttributedString * games = [[NSAttributedString alloc] initWithString:[NSString  stringWithFormat:@"Games Played\n%d\n", [GameStats gamesPlayed]] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Courier New" size:fontSize]}];
    
    NSAttributedString * ratio = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Your Skill Ratio\n%.2f", ([GameStats highestScore] / (float)[GameStats gamesPlayed])] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Courier New" size:fontSize]}];
    
    
    
    [highScore appendAttributedString:games];
    [highScore appendAttributedString:ratio];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [highScore size].width, [highScore size].height)];
    label.attributedText = highScore;
    
    label.center = CGPointMake(self.bounds.size.width / 2, label.frame.size.height / 2);

    label.numberOfLines = 0;
    label.textAlignment  = NSTextAlignmentCenter;
    
    [self addSubview:label];
}

- (void)begone
{
    [UIView animateWithDuration:.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    
    self.isShown = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self begone];
}




@end
