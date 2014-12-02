//
//  GameViewController.m
//  Method To Madness
//
//  Created by Brian Tracy on 9/13/14.
//  Copyright (c) 2014 Brian Tracy. All rights reserved.
//

#import "UIButton+NavigationButton.h"
#import "GameViewController.h"
#import "UIFont+GameFonts.h"
#import "GraphicsHeader.h"

@interface GameViewController ()

@end

@implementation GameViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LaunchImage-700"]]];
    
    self.defaults = [NSUserDefaults standardUserDefaults];
    self.gameAttributes = @{@"VisibleGridSize" : @3,
                            @"GameFont" : @"Courier New",
                            @"GridSize" : @5,
                            @"OperatorSize" : @4
                            };
    [self newGame];
    
    [self.defaults setObject:[NSNumber numberWithInt:0] forKey:@"savedstring"];
    [self setUpNavigation];
    
    self.gameView.alpha = 0;
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [UIView animateWithDuration:.5 animations:^{
        self.gameView.alpha = 1;
    }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.gameView.alpha = 0;
}

- (void) quitWithReset:(BOOL)resetRequest {
    [self.gameView removeFromSuperview];
    [self.gameView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    self.gameView = nil;
    self.game = nil;
    for (UIGestureRecognizer *recognizer in self.gameView.gestureRecognizers) {
        [self.gameView removeGestureRecognizer:recognizer];
    }
    if (resetRequest) {
        [self newGame];
    }
}

- (void)newGame {
    if (self.game) {
        if (![self.defaults objectForKey:@"savedstring"]) {
            NSNumber *savestring = [NSNumber numberWithInt:0];
            [self.defaults setObject:savestring forKey:@"savedstring"];
        }
    }
    self.gameView = [[GameView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view addSubview:self.gameView];
    [self.gameView setDelegate: self];
    self.game = [[Game alloc] init];
    [self.game setDelegate: self];
    [self.game newGameWithGameAttributes:self.gameAttributes];
    [[self.gameView highScoreLabel] setText: [NSString stringWithFormat:@"%i", [[self.defaults objectForKey:@"savedstring"] intValue]]];
    self.gameIsOver = NO;
    
    [self setUpNavigation];
}

- (void)parseDirection:(Direction)swipeDirection {
    if (swipeDirection != None) {
        [self.gameView moveTilesInDirection: swipeDirection];
    }
}

- (void)setSwipeDirection:(UISwipeGestureRecognizer *)swipe {
    switch (swipe.direction) {
        case UISwipeGestureRecognizerDirectionUp:
            [self.game moveBoardInDirection:Up];
            break;
        case UISwipeGestureRecognizerDirectionDown:
            [self.game moveBoardInDirection:Down];
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            [self.game moveBoardInDirection:Left];
            break;
        case UISwipeGestureRecognizerDirectionRight:
            [self.game moveBoardInDirection:Right];
            break;
        default: break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setAttributes:(NSDictionary *)attributes {
    //if gamestate is NO, then the game properties such as tile values, position, etc need to be initialized
    //if gamestate is YES, then the game has already been initialized and the controller may parse the model information
    if ([[attributes objectForKey:GameStateInGameKey] boolValue] == NO) {
        [self.gameView newGameWithTileValues:[attributes objectForKey:InitialTileArrayKey] andGameAttributes:self.gameAttributes];
        [self parseOperatorArray:[attributes objectForKey:InitialOperatorStackKey]];
        [[[self gameView] focusTileView] setBackgroundColor:[UIColor colorWithRed:255/255 green:30.0/255 blue:30.0/255 alpha:1.0]];
    } else {
        if (!self.gameIsOver) {
            [self parseActiveTileArray:[attributes objectForKey:ActiveTileArrayKey]];
            [self parseDirection: [[attributes objectForKey:SwipeDirectionKey] intValue]];
            [self parseOperatorArray:[attributes objectForKey:OperatorStackKey]];
            [[[self gameView] focusTileView] setVal:[[attributes objectForKey:FocusTileInfoKey] intValue]];
        }
    }
    [self.gameView.focusTileView setNeedsDisplay];
}

- (void)swipeComplete {
    self.gameIsOver = self.game.isOver;
    
    if (self.gameIsOver) {
        [self.game.gameStats writeToFile];
        
        NSString * body = [NSString stringWithFormat:@"%@", self.game.dividedByZero ? @"You Divided By Zero" : [NSString stringWithFormat:@"Nice Job, Your Score Was %lld", self.game.gameStats.score ]];
        
        [[[UIAlertView alloc] initWithTitle:@"Game Over" message:body delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        
        //NSLog(@"Game is Over");
    }
}

- (void)parseOperatorArray:(NSArray *)array {
    NSMutableString *operatorString = [[NSMutableString alloc] initWithString:@""];
    for (int i = 1; i<[[self.gameAttributes objectForKey:@"OperatorSize"] integerValue]; i++) {
        [operatorString appendString:[NSString stringWithFormat:@"%@", array[i]]];
    }
    [self.gameView operatorLabel].text = operatorString;
    [self.gameView nextOperatorLabel].text = [NSString stringWithFormat:@"%@", array[0]];
}

- (void)parseActiveTileArray: (NSArray *)array {
    int dim = [[self.gameAttributes objectForKey:@"GridSize"] intValue];
    for (int x = 0; x<dim; x++) {
        for (int y = 0; y<dim; y++) {
            if([[array objectAtIndex:x*dim+y] boolValue] == NO) {
                [[self.gameView.tileViewArray objectAtIndex:x by:y] setBackgroundColor: [UIColor grayColor]];
                [[self.gameView.tileViewArray objectAtIndex:x by:y] setNeedsDisplay];
            }
        }
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)setUpNavigation
{
    CGFloat padding = 5.0f;
    CGFloat size = 30;
    
    NSAttributedString * back = [[NSAttributedString alloc] initWithString:@"back" attributes:@{NSFontAttributeName: [UIFont fontWithName:[UIFont gameFontName] size:size]}];
    UIButton * backB = [UIButton buttonWithText:back center:CGPointZero callBackObject:self callBack:@selector(back)];
    [backB setFrame:CGRectMake(5.0, SCREEN_HEIGHT - (backB.frame.size.height + 5.0), backB.frame.size.width, backB.frame.size.height)];
    [self.gameView addSubview:backB];
    
    
    
    NSAttributedString * reset = [[NSAttributedString alloc] initWithString:@"reset" attributes:@{NSFontAttributeName: [UIFont fontWithName:[UIFont gameFontName] size:size]}];
    
    UIButton * resetB = [UIButton buttonWithText:reset center:CGPointZero callBackObject:self callBack:@selector(reset)];
    [resetB setFrame:CGRectMake(SCREEN_WIDTH - (resetB.frame.size.width + padding), SCREEN_HEIGHT - (resetB.frame.size.height + padding), resetB.frame.size.width, resetB.frame.size.height)];
    
    [self.gameView addSubview:resetB];
    
}

- (void)reset
{
    [self.game.gameStats writeToFile];
    self.game.gameStats = [GameStats new];
    [self quitWithReset:YES];
}

- (void)back
{
    [UIView animateWithDuration:.75 animations:^{
        self.gameView.alpha = 0;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }];
    
}
@end

