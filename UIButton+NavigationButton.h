//
//  UIButton+NavigationButton.h
//  Method To Madness
//
//  Created by Brian Tracy on 9/13/14.
//  Copyright (c) 2014 Brian Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (NavigationButton)

+ (instancetype)buttonWithText:(NSAttributedString *)text
                        center:(CGPoint)center
                callBackObject:(id)callBackObject
                      callBack:(SEL)callBack;

@end
