//
//  UIButton+NavigationButton.m
//  Method To Madness
//
//  Created by Brian Tracy on 9/13/14.
//  Copyright (c) 2014 Brian Tracy. All rights reserved.
//

#import "UIButton+NavigationButton.h"

@implementation UIButton (NavigationButton)

+ (instancetype)buttonWithText:(NSAttributedString *)text
                        center:(CGPoint)center
                callBackObject:(id)callBackObject
                      callBack:(SEL)callBack
{
    UIButton * button = [self buttonWithType:UIButtonTypeRoundedRect];
    
    CGRect frame = CGRectZero;
    frame.size = [text size];
    [button setFrame:frame];
    [button setCenter:center];
    
    [button setAttributedTitle:text forState:UIControlStateNormal];
    
    [button addTarget:callBackObject action:callBack forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

@end