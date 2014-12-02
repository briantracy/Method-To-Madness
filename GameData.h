//
//  GameData.h
//  Method To Madness
//
//  Created by Brian Tracy on 9/13/14.
//  Copyright (c) 2014 Brian Tracy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol GameData <NSObject>
- (void)setAttributes:(NSDictionary *)attributes;

@end

NSString *InitialTileArrayKey;
NSString *InitialOperatorStackKey;
NSString *ActiveTileArrayKey;
NSString *OperatorStackKey;
NSString *SwipeDirectionKey;
NSString *FocusTileInfoKey;
NSString *GameStateInGameKey;


