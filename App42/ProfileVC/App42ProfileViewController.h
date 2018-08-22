//
//  App42ProfileViewController.h
//  App42
//
//  Created by Purnima Singh on 04/07/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

@interface App42ProfileViewController : UIViewController <SlideNavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *pointsCount;
@property (strong, nonatomic) IBOutlet UILabel *notificationCount;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UILabel *mobileLabel;

@end
