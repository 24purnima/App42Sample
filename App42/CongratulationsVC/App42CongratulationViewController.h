//
//  App42CongratulationViewController.h
//  App42
//
//  Created by Purnima Singh on 04/07/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

@protocol congartuationPopup <NSObject>
-(void)popupClose;
@end

@interface App42CongratulationViewController : UIViewController <SlideNavigationControllerDelegate>

@property (nonatomic, assign) int amountValue;

@property (strong, nonatomic) IBOutlet UILabel *amountlabel;
@property (strong, nonatomic) IBOutlet UIButton *continueButton;

- (IBAction)continueBtnClick:(id)sender;

@property (nonatomic, weak) id <congartuationPopup> delegate;
@end
