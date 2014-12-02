//
//  MainMenuViewController.m
//  Method To Madness
//
//  Created by Brian Tracy on 9/13/14.
//  Copyright (c) 2014 Brian Tracy. All rights reserved.
//

#import "MainMenuViewController.h"
#import "GameViewController.h"
#import "StatisticsViewController.h"
#import "UIButton+NavigationButton.h"
#import <SpriteKit/SKView.h>
#import "SplashScene.h"
#import <QuartzCore/QuartzCore.h>
#import "UIFont+GameFonts.h"
#import "GraphicsHeader.h"
#import "StatisticsView.h"
#import "InstructionsViewController.h"

@interface MainMenuViewController ()
@property (nonatomic) GameViewController       * gameViewController;
@property (nonatomic) StatisticsViewController * statisticsViewController;
@property (nonatomic) UIView                   * contentLayer;
@property (nonatomic) SKView                   * spriteView;

@property (nonatomic) StatisticsView           * statsView;
@property (nonatomic) InstructionsViewController * instructionsViewController;

@end

@implementation MainMenuViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor orangeColor];
    }
    return self;
}

- (void)setUpTitle //Method to\n Madness
{
    
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
    NSAttributedString * text = [[NSAttributedString alloc] initWithString:@"Method To\n Madness" attributes:@{NSFontAttributeName: [UIFont fontWithName:[UIFont gameFontName] size:45]}];
    CGSize textSize = [text size];
    CGPoint center = CGPointMake(CGRectGetMidX(self.view.frame), 45);
    
    CGRect final;
    final.size = textSize;
    
    [label setFrame:final];
    label.center = center;
    label.attributedText = text;
    label.numberOfLines = 0;
    
    [self.contentLayer addSubview:label];
}

- (void)setUpPlayGame
{
    
    NSAttributedString * text = [[NSAttributedString alloc] initWithString:@"Play Game"
                                                                attributes:@{NSFontAttributeName: [UIFont fontWithName:[UIFont gameFontName] size:20]}];
    CGPoint center = CGPointMake(CGRectGetMidX(self.view.frame), SCREEN_HEIGHT - 100);
    
    UIButton * playGame = [UIButton buttonWithText:text center:center callBackObject:self callBack:@selector(transitionToGameViewController)];
    
    [self.contentLayer addSubview:playGame];
}

- (void)setUpStatistics
{
    NSAttributedString * text = [[NSAttributedString alloc] initWithString:@"My Statistics"
                                                                attributes:@{NSFontAttributeName: [UIFont fontWithName:[UIFont gameFontName] size:20]}];
    CGPoint center = CGPointMake(CGRectGetMidX(self.view.frame), SCREEN_HEIGHT - 50);
    
    UIButton * statistics = [UIButton buttonWithText:text center:center callBackObject:self callBack:@selector(transitionToStatisticsViewController)];
    
    [self.contentLayer addSubview:statistics];
}

- (void)transitionToStatisticsViewController
{
//    if (!self.statsView) {
//        self.statsView = [[StatisticsView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
//    }
//    
//    if (!self.statsView.isShown) {
//        [self.statsView render];
//        self.statsView.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame));
//        [self.contentLayer addSubview:self.statsView];
//    }
//    else {
//        [self.statsView begone];
//    }
    
    
    if (!self.instructionsViewController) self.instructionsViewController = [[InstructionsViewController alloc] init];
    
    [self presentViewController:self.instructionsViewController animated:YES completion:^{
    
    }];

    
    
}

- (void)transitionToGameViewController
{
    if (!self.gameViewController) self.gameViewController = [[GameViewController alloc] init];
    

    [self presentViewController:self.gameViewController animated:YES completion:^{
        self.statsView.isShown = NO;
        [self.statsView removeFromSuperview];
    }];
    
    
    
}



- (void)setUpSpriteKit
{
    self.spriteView = [[SKView alloc] initWithFrame:self.view.frame];
    [self.spriteView setBackgroundColor:[UIColor blueColor]];
    
    [self.view addSubview:self.spriteView];
    SplashScene * scene = [[SplashScene alloc] initWithSize:self.view.frame.size];
    [self.spriteView presentScene:scene];
}





- (void)viewDidAppear:(BOOL)animated
{
    [self setLabelsAlpha:1 animationSpeed:1];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self setLabelsAlpha:0 animationSpeed:0];
}

- (void)setLabelsAlpha:(int)alpha animationSpeed:(int)speed
{
    
    [UIView animateWithDuration:speed animations:^{
        for (UIView * v in [self.contentLayer subviews]) {
            [v setAlpha:alpha];
        }
    }];
}

- (void)viewDidLoad
{
    [self setUpSpriteKit];
    self.contentLayer = [[UIView alloc] initWithFrame:self.view.frame];
    self.contentLayer.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.contentLayer];
    [self setUpTitle];
    [self setUpPlayGame];
    [self setUpStatistics];
    
}






- (BOOL)prefersStatusBarHidden
{
    return YES;
}





@end

