//
//  GameView.h
//  Method To Madness
//
//  Created by Brian Tracy on 9/13/14.
//  Copyright (c) 2014 Brian Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeDelegate.h"
#import "HelperArray.h"
#import "TileView.h"


@interface GameView : UIView

-(void)setUpGestureRecognizers;
-(void)newGameWithTileValues:(NSArray *)tileValues andGameAttributes:(NSDictionary *)attributes;
-(void)setUpLabels;
-(void)moveTilesInDirection:(Direction)swipeDirection;

@property (nonatomic, strong) id<SwipeDelegate> delegate;
@property HelperArray *tileViewArray;
@property TileView *focusTileView;
@property UILabel *operatorLabel;
@property UILabel *highScoreLabel;
@property UILabel *nextOperatorLabel;
@property UIView *gridView;


@end
