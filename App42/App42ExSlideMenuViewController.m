
//
//  App42ExSlideMenuViewController.m
//  App42
//
//  Created by Purnima Singh on 03/07/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import "App42ExSlideMenuViewController.h"
#import "UIApplication+App42UIApplication.h"
#import "App42HomeViewController.h"
#import "App42CartViewController.h"
#import "App42WishlistViewController.h"
#import "App42ChatViewController.h"
#import "App42CustomerSupportViewController.h"

@interface App42ExSlideMenuViewController ()

@end

@implementation App42ExSlideMenuViewController

-(BOOL)isTagetViewController {
    UIViewController *vc = [UIApplication topViewController];
    if ([vc isKindOfClass:[App42HomeViewController class]]
        || [vc isKindOfClass:[App42CartViewController class]]
        || [vc isKindOfClass:[App42WishlistViewController class]]
        || [vc isKindOfClass:[App42ChatViewController class]]
        || [vc isKindOfClass:[App42CustomerSupportViewController class]]) {
        return YES;
    }
    return NO;
}

-(void)track:(TrackAction)action {
    switch (action) {
        case TrackActionLeftTapOpen:
            NSLog(@"TrackAction: left tap open.");
            break;
        case TrackActionLeftTapClose:
            NSLog(@"TrackAction: left tap close.");
            break;
        case TrackActionLeftFlickOpen:
            NSLog(@"TrackAction: left flick open.");
            break;
        case TrackActionLeftFlickClose:
            NSLog(@"TrackAction: left flick close.");
            break;
        case TrackActionRightTapOpen:
            NSLog(@"TrackAction: right tap open.");
            break;
        case TrackActionRightTapClose:
            NSLog(@"TrackAction: right tap close.");
            break;
        case TrackActionRightFlickOpen:
            NSLog(@"TrackAction: right flick open.");
            break;
        case TrackActionRightFlickClose:
            NSLog(@"TrackAction: right flick close.");
            break;
        default:
            break;
    }
}

@end
