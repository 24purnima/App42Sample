//
//  App42WishlistViewController.h
//  App42
//
//  Created by Purnima Singh on 15/06/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

@interface App42WishlistViewController : UIViewController <SlideNavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) BOOL isFromHome;
@property (strong, nonatomic) IBOutlet UITableView *wishlistTableView;

@end
