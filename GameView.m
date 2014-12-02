//
//  GameView.m
//  Method To Madness
//
//  Created by Brian Tracy on 9/13/14.
//  Copyright (c) 2014 Brian Tracy. All rights reserved.
//

#import "GameView.h"
#import "UIFont+GameFonts.h"

@implementation GameView
int GRID_SPACING;
int TILE_SIZE;
int GRID_SIZE;
CGRect GRID_BOUNDS;



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self setOpaque:NO];
        [self setUpGestureRecognizers];
        // Initialization code
    }
    
    return self;
}

- (void)setUpGridCover {
    //covers upper and bottom tile to create the appearance of an equilateral grid
    UIView *topCover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, GRID_BOUNDS.origin.y)];
    UIView *bottomCover = [[UIView alloc] initWithFrame:CGRectMake(0, GRID_BOUNDS.origin.y+GRID_BOUNDS.size.height, self.frame.size.width, 400)];
    [bottomCover setBackgroundColor:[UIColor whiteColor]];
    [topCover setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:bottomCover];
    [self addSubview:topCover];
}

- (void)setUpLabels {
    [self setUpGridCover];
    //next 3 operators
    self.operatorLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height/2-GRID_BOUNDS.size.height/2)];
    self.operatorLabel.textAlignment =  NSTextAlignmentCenter;
    self.operatorLabel.font = [UIFont fontWithName:[UIFont gameFontName] size:(36.0)];
    [self addSubview:self.operatorLabel];
    
    
    //"big operator" label shows the current operator being used
    self.nextOperatorLabel = [ [UILabel alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width/2-TILE_SIZE/2, self.frame.size.height/2-GRID_BOUNDS.size.height/2)];
    self.nextOperatorLabel.textAlignment = NSTextAlignmentCenter;
    self.nextOperatorLabel.font = [UIFont fontWithName:[UIFont gameFontName] size:(66.0)];
    [self addSubview:self.nextOperatorLabel];
    [self setNeedsDisplay];
    
    /* TODO: THIS IS NOW DEPRECATED, MOVED TO GAMEVIEWCONTROLLER */
    
//    //reset button that initiates a new game instance
//    UILabel *resetLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2+GRID_BOUNDS.size.height/2, self.frame.size.width, self.frame.size.height-(self.frame.size.height/2+GRID_BOUNDS.size.height/2))];
//    resetLabel.textAlignment = NSTextAlignmentCenter;
//    resetLabel.font = [UIFont fontWithName:GAME_FONT size:40.0];
//    resetLabel.text = @"reset";
//    [self addSubview:resetLabel];
//    resetLabel.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reset)];
//    [resetLabel addGestureRecognizer:tapGesture];
}

- (void)reset {
    [self.delegate quitWithReset:YES];
}

- (void)newGameWithTileValues:(NSArray *)tileValues andGameAttributes:(NSDictionary *)attributes {
    //drawing constants
    GRID_SIZE = [[attributes objectForKey:@"GridSize"] intValue];
    GRID_SPACING = self.frame.size.width/[[attributes objectForKey:@"VisibleGridSize"] intValue];
    
    //TILE_SIZE = [[attributes objectForKey:@"TileSize"] integerValue];
    TILE_SIZE = GRID_SPACING-10;
    int visibleGridSize = [[attributes objectForKey:@"VisibleGridSize"]intValue];
    
    GRID_BOUNDS = CGRectMake(self.center.x-GRID_SPACING*(visibleGridSize-1)/2-TILE_SIZE/2,
                             self.center.y-GRID_SPACING*(visibleGridSize-1)/2-TILE_SIZE/2,
                             self.center.x-GRID_SPACING*(visibleGridSize-1)/2-TILE_SIZE/2+GRID_SPACING*(visibleGridSize-1)+TILE_SIZE-5,
                             self.center.x-GRID_SPACING*(visibleGridSize-1)/2-TILE_SIZE/2+GRID_SPACING*(visibleGridSize-1)+TILE_SIZE-5);
    
    self.gridView = [[UIView alloc] initWithFrame:GRID_BOUNDS];
    
    self.tileViewArray = [[HelperArray alloc] initWithDimension:GRID_SIZE];
    for (int x = 0; x<self.tileViewArray.dimension; x++) {
        for (int y = 0; y<self.tileViewArray.dimension; y++) {
            TileView *tile = [[TileView alloc] initWithFrame:
                              CGRectMake(
                                         self.center.x+GRID_SPACING*(x-((GRID_SIZE-1)/2))-TILE_SIZE/2,
                                         self.center.y+GRID_SPACING*(y-((GRID_SIZE-1)/2))-TILE_SIZE/2,
                                         TILE_SIZE,
                                         TILE_SIZE
                                         )];
            tile.val = [tileValues[x+y*GRID_SIZE] intValue];
            tile.label.font = [UIFont fontWithName:[UIFont gameFontName] size:TILE_SIZE/4];
            [self.tileViewArray addObject:tile];
            [self addSubview:tile];
        }
        
    }
    self.focusTileView = [[TileView alloc] initWithFrame:CGRectMake(self.center.x-TILE_SIZE/2,
                                                                    self.center.y-TILE_SIZE/2,
                                                                    TILE_SIZE,
                                                                    TILE_SIZE)];
    self.focusTileView.val = [[self.tileViewArray objectAtIndex:(GRID_SIZE-1)/2 by:(GRID_SIZE-1)/2] val];
    self.focusTileView.label.font = [UIFont fontWithName:[UIFont gameFontName] size:TILE_SIZE/4];
    [self addSubview:self.focusTileView];
    
    //set up labels
    [self setUpLabels];
}

-(void)moveTilesInDirection:(Direction)swipeDirection {
    const NSTimeInterval yahliMalchin = .15;
    
    
    for (int x = 0; x<GRID_SIZE; x++) {
        for (int y = 0; y<GRID_SIZE; y++) {
            OrderedPair pair = {x,y};
            [UIView animateWithDuration:yahliMalchin animations:^{
                TileView *tile = [self.tileViewArray objectAtIndex:pair];
                 if (swipeDirection == Up) {
                    tile.center = CGPointMake(tile.center.x, tile.center.y-GRID_SPACING);
                }
                if (swipeDirection == Down) {
                    tile.center = CGPointMake(tile.center.x, tile.center.y+GRID_SPACING);
                }
                if (swipeDirection == Left) {
                    tile.center = CGPointMake(tile.center.x-GRID_SPACING, tile.center.y);
                }
                if (swipeDirection == Right) {
                    tile.center = CGPointMake(tile.center.x+GRID_SPACING, tile.center.y);
                }
            } completion:^(BOOL finished) {
                if (x==GRID_SIZE-1 && y==GRID_SIZE-1) {
                    [self.delegate swipeComplete];
                }
            }];
        }
    }
    
}



-(void)setUpGestureRecognizers {
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetected:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(swipeDetected:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipeRight];
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]  initWithTarget:self action:@selector(swipeDetected:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self addGestureRecognizer:swipeUp];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetected:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self addGestureRecognizer:swipeDown];
}

-(void)swipeDetected:(UISwipeGestureRecognizer *)swipeGesture {
    if ([self.delegate respondsToSelector:@selector(setSwipeDirection:)]) {
        [self.delegate setSwipeDirection:swipeGesture];
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
