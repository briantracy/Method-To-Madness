//
//  SwipeDelegate.h
//  Method To Madness
//
//  Created by Brian Tracy on 9/13/14.
//  Copyright (c) 2014 Brian Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol SwipeDelegate <NSObject>

- (void)setSwipeDirection:(UISwipeGestureRecognizer*)swipe;
- (void)swipeComplete;
- (void)quitWithReset:(BOOL)resetRequest;

@end