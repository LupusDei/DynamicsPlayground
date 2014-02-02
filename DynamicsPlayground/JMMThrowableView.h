//
//  JMMThrowableView.h
//  DynamicsPlayground
//
//  Created by Justin Martin on 1/31/14.
//  Copyright (c) 2014 JMM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMMThrowableView : UIView

@property (nonatomic, strong) UIDynamicItemBehavior *behaviors;
@property (nonatomic, strong) UIDynamicAnimator *animator;

@end
