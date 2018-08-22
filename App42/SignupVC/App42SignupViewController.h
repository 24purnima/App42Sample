//
//  App42SignupViewController.h
//  App42
//
//  Created by Purnima Singh on 15/06/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface App42SignupViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *signupScrollView;
@property (strong, nonatomic) IBOutlet UIView *signupContentView;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *mobileTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *retypeTextField;
@property (strong, nonatomic) IBOutlet UIButton *signUpButton;


- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)signUpButtonClicked:(id)sender;

@end
