//
//  App42ChatViewController.h
//  App42
//
//  Created by Purnima Singh on 15/06/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

@interface App42ChatViewController : UIViewController <SlideNavigationControllerDelegate>

@property (nonatomic, assign) BOOL isCustomerSupport;

@end
