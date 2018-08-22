//
//  App42CartViewController.h
//  App42
//
//  Created by Purnima Singh on 15/06/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

@interface App42CartViewController : UIViewController <SlideNavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) BOOL isFromFeature;
@property (strong, nonatomic) IBOutlet UITableView *cartTableView;
@property (strong, nonatomic) IBOutlet UILabel *totalAmountlabel;

- (IBAction)placeOrderButtonClick:(id)sender;
@end
