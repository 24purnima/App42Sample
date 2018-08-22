//
//  App42CustomerSupportViewController.h
//  App42
//
//  Created by Purnima Singh on 15/06/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

@interface App42CustomerSupportViewController : UIViewController <SlideNavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *supportTable;
@property (strong, nonatomic) IBOutlet UIButton *callusButton;
@property (strong, nonatomic) IBOutlet UIButton *chatWithusButton;
- (IBAction)callusBtnClick:(id)sender;
- (IBAction)chatWithusBtnClick:(id)sender;

@end
