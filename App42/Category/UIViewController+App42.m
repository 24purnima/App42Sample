//
//  UIViewController+App42.m
//  App42
//
//  Created by Purnima Singh on 03/07/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import "UIViewController+App42.h"
#import "SlideMenuController.h"

@implementation UIViewController (App42)

-(void)setNavigationBarItem {
    [self addLeftBarButtonWithImage:[UIImage imageNamed:@"menu-filled"]];
    [self addRightBarButtonWithImage:[UIImage imageNamed:@"menu-filled"]];
    [self.slideMenuController removeLeftGestures];
    [self.slideMenuController removeRightGestures];
    [self.slideMenuController addLeftGestures];
    [self.slideMenuController addRightGestures];
}

-(void)removeNavigationBarItem {
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    [self.slideMenuController removeLeftGestures];
    [self.slideMenuController removeRightGestures];
}

@end
