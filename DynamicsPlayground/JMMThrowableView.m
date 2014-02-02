//
//  JMMThrowableView.m
//  DynamicsPlayground
//
//  Created by Justin Martin on 1/31/14.
//  Copyright (c) 2014 JMM. All rights reserved.
//

#import "JMMThrowableView.h"

@implementation JMMThrowableView {
    BOOL _beingDragged;
    CGPoint _previousTouchPoint;
    UIGravityBehavior *_grav;
    UICollisionBehavior *_col;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

-(void) handlePan:(UIPanGestureRecognizer *)pan {
    CGPoint touch = [pan locationInView:self.superview];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
            NSLog(@"PAN STARTED");
        for (UIDynamicBehavior *b in [self.animator behaviors]) {
            if([b class] == [UIGravityBehavior class])
                _grav = (UIGravityBehavior *)b;
            if ([b class] == [UICollisionBehavior class]) {
                _col = (UICollisionBehavior *) b;
            }
        }
        [_grav removeItem:self];
        [_col removeItem:self];
        [self.behaviors removeItem:self];
        _beingDragged = YES;
        _previousTouchPoint = touch;
    }
    else if (pan.state == UIGestureRecognizerStateChanged && _beingDragged) {
        CGFloat yOffset = _previousTouchPoint.y - touch.y;
        CGFloat xOffset = _previousTouchPoint.x - touch.x;
        self.center = CGPointMake(self.center.x - xOffset, self.center.y - yOffset);
        _previousTouchPoint = touch;
    }
    else if (pan.state == UIGestureRecognizerStateEnded && _beingDragged) {
            NSLog(@"PAN ~~~ ENDED");
        _beingDragged = NO;
        [_grav addItem:self];
        [_col addItem:self];
        [self.behaviors addItem:self];
        [self.behaviors addLinearVelocity:[pan velocityInView:self.superview] forItem:self];
        [self.animator updateItemUsingCurrentState:self];
    }
}
@end
