//
//  App42MenuViewController.h
//  App42
//
//  Created by Purnima Singh on 15/06/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

//typedef enum : NSInteger{
//    LeftMenuMain = 0,
//    LeftMenuSwift,
//    LeftMenuJava,
//    LeftMenuGo,
//    LeftMenuNonMenu
//} LeftMenu;


@interface App42MenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *menuTableView;
@property (strong, nonatomic) IBOutlet UIView *profileBackView;
@property (strong, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *pointsCount;

@property (retain, nonatomic) NSArray *menus;
@property (retain, nonatomic) NSArray *menusImages;
@property (nonatomic, assign) BOOL slideOutAnimationEnabled;

@end
