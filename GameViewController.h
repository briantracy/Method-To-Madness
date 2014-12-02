//
//  GameViewController.h
//  Method To Madness
//
//  Created by Brian Tracy on 9/13/14.
//  Copyright (c) 2014 Brian Tracy. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "GameData.h"
#import "SwipeDelegate.h"
#import "Game.h"
#import "GameView.h"
#import "HelperArray.h"

@interface GameViewController : UIViewController <GameData, SwipeDelegate>

@property GameView *gameView;
@property Game *game;
@property NSUserDefaults *defaults;
@property NSDictionary *gameAttributes;
@property BOOL gameIsOver;

@end
