//
//  JMMViewController.m
//  DynamicsPlayground
//
//  Created by Justin Martin on 1/31/14.
//  Copyright (c) 2014 JMM. All rights reserved.
//

#import "JMMViewController.h"
#import "JMMThrowableView.h"

@interface JMMViewController () <UICollisionBehaviorDelegate>
@end

@implementation JMMViewController {
    JMMThrowableView *_mainSquare;
    UIDynamicAnimator *_animator;
    UIGravityBehavior *_gravity;
    UICollisionBehavior *_collision;
    int _contacts;
    int _contactTrigger;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	_mainSquare = [[JMMThrowableView alloc] initWithFrame:CGRectMake(120, 100, 50, 50)];
    _mainSquare.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_mainSquare];
    UIView *barrier  = [[UIView alloc] initWithFrame:CGRectMake(0, 300, 130, 20)];
    barrier.backgroundColor = [UIColor redColor];
    [self.view addSubview:barrier];

    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    _gravity = [[UIGravityBehavior alloc] initWithItems:@[_mainSquare]];
    _gravity.angle = M_PI / 2;
    _gravity.magnitude = 0.4;
    [_animator addBehavior:_gravity];
    _collision = [[UICollisionBehavior alloc] initWithItems:@[_mainSquare]];
    _collision.translatesReferenceBoundsIntoBoundary = YES;
    [_animator addBehavior:_collision];
    [_collision addBoundaryWithIdentifier:@"barrier" fromPoint:barrier.frame.origin toPoint:[self rightEdge:barrier]];
    
//    __block int i = 0;
    _collision.action = ^{
//        i += 1;
//        if (i % 5 == 0) {
//            UIView *another = [[UIView alloc]initWithFrame: CGRectMake(100, 100, 100, 100)];
//            another.center = square.center;
//            another.transform = square.transform;
//            another.backgroundColor = [UIColor clearColor];
//            another.layer.borderColor = [UIColor grayColor].CGColor;
//            another.layer.borderWidth = 1;
//            [self.view addSubview:another];
//        }
    };
    _collision.collisionDelegate = self;
    
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[_mainSquare]];
    itemBehavior.elasticity = 0.98;
    itemBehavior.angularResistance = 0.1;
    itemBehavior.friction = 0;
    itemBehavior.resistance = 0.1;
    [_animator addBehavior:itemBehavior];
    _mainSquare.behaviors = itemBehavior;
    _mainSquare.animator = _animator;
    _contactTrigger = 7;
    
}

-(void) collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p {
    UIView *view = (UIView *)item;
    view.backgroundColor = [UIColor yellowColor];
    [UIView animateWithDuration:0.3 animations:^{
    	view.backgroundColor = [UIColor grayColor];
    }];
    _contacts += 1;
    if (_contacts % _contactTrigger == 0 && _contactTrigger < 40) {
        NSLog(@"Contacts triigger: %d", _contactTrigger);
        _contactTrigger +=1;
        int r = arc4random() % 300;
        int r2 = arc4random() % 200;
        UIView *square = [[UIView alloc] initWithFrame:CGRectMake(r, r2, 10, 10)];
        square.backgroundColor = [UIColor grayColor];
        [self.view addSubview:square];
        [_collision addItem:square];
        [_gravity addItem:square];
//        if (_contacts % 6 == 0) {
//            NSLog(@"Attaching %d", _contacts);
//            UIAttachmentBehavior *attach = [[UIAttachmentBehavior alloc] initWithItem:view attachedToItem:square];
//            [_animator addBehavior:attach];
//        }
//        if (_contacts % 3 == 0) {
//            NSLog(@"Triiggering the push %d", _contacts);
//            UIPushBehavior *push = [[UIPushBehavior alloc] initWithItems:@[_mainSquare] mode:UIPushBehaviorModeInstantaneous];
//            push.magnitude = 1;
//            float a = arc4random() / M_PI;
//            push.angle = a;
//            [_animator addBehavior:push];
//            push.active = YES;
//            
//        }
        UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[square]];
        itemBehavior.angularResistance = 1;
        itemBehavior.friction = 0;
        itemBehavior.elasticity = 0.95;
        itemBehavior.resistance = 0;
        
        [_animator addBehavior:itemBehavior];
        _contacts = 0;
    }
}


-(CGPoint) rightEdge:(UIView *)view {
    return CGPointMake(view.frame.origin.x + view.frame.size.width, view.frame.origin.y);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
