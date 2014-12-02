//
//  SplashScene.m
//  Method To Madness
//
//  Created by Brian Tracy on 9/13/14.
//  Copyright (c) 2014 Brian Tracy. All rights reserved.
//


#import "SplashScene.h"
#import "UIColor+CustomColors.h"
#import "GraphicsHeader.h"


#define SQUARE_WIDTH 30


@implementation SplashScene

- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        self.backgroundColor = [SKColor whiteColor];
        self.physicsWorld.gravity = CGVectorMake(0, 0);
    }
    return self;
}

- (void)didMoveToView:(SKView *)view
{
    [self start];
    [self setUpBoundaries];
    [self setUpGradient];
    
}

- (void)setUpGradient
{
    self.view.opaque = NO;
}

- (void)setUpBoundaries
{
    [self setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame]];
    self.physicsBody.restitution = 1.0f;
    
}

- (void)start
{
    for (int i = 0; i < 10; i++) {
        SKShapeNode * node = [SKShapeNode node];
        node.name = @"tile";
        CGRect rect = CGRectMake(0, 0, SQUARE_WIDTH, SQUARE_WIDTH);
        CGPathRef path = CGPathCreateWithRoundedRect(rect, 5, 5, NULL);
        
        node.path = path;
        //CGPathRelease(path);
        node.position = [self randomPosition];
        node.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:node.path];
        node.strokeColor = [UIColor blackColor];
        node.lineWidth = .25;
        node.fillColor = [UIColor tileColor];
        node.physicsBody.velocity = [self randomVelocity];
        node.physicsBody.restitution = 1.0f;
        node.physicsBody.friction = 0.0f;
        //        node.physicsBody.mass = 0;
        node.physicsBody.linearDamping = 0.0f;
        node.physicsBody.angularDamping = 0.0f;
        
        SKLabelNode * label = [SKLabelNode node];
        label.text = [NSString stringWithFormat:@"%d", arc4random_uniform(6)];
        label.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        label.position = CGPointMake(SQUARE_WIDTH / 2, SQUARE_WIDTH / 2);
        label.fontName = @"Courier New Bold";
        label.fontColor = [SKColor blackColor];
        label.fontSize = 15;
        [node addChild:label];
        
        
        if (i == 0) { node.fillColor = [UIColor focusTileColor]; }
        
        [self addChild:node];
    }
}

- (CGVector)randomVelocity
{
    int kMax = 250;
    CGVector vec;
    vec.dx  = (CGFloat)arc4random_uniform(kMax);
    vec.dy  = (CGFloat)arc4random_uniform(kMax);
    return vec;
}


- (CGPoint)randomPosition
{
    CGPoint p;
    p.x = arc4random_uniform(SCREEN_WIDTH - SQUARE_WIDTH);
    p.y = arc4random_uniform(SCREEN_HEIGHT - SQUARE_WIDTH);
    
    return p;
}

@end
