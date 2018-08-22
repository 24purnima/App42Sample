//
//  App42PaymentViewController.h
//  App42
//
//  Created by Purnima Singh on 15/06/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "App42CongratulationViewController.h"
#import "SlideNavigationController.h"

@interface App42PaymentViewController : UIViewController <congartuationPopup>


@property (strong, nonatomic) IBOutlet UIView *netBankingView;
@property (strong, nonatomic) IBOutlet UIView *creditCardView;
@property (strong, nonatomic) IBOutlet UIView *loyaltyPointsView;
@property (strong, nonatomic) IBOutlet UIView *addNewPaymentView;
@property (strong, nonatomic) IBOutlet UILabel *totalAmountLabel;

@property (strong, nonatomic) IBOutlet UIButton *placeOrderButton;
- (IBAction)placeOrderBtnClick:(id)sender;


@end
