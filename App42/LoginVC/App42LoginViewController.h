//
//  App42LoginViewController.h
//  App42
//
//  Created by Purnima Singh on 15/06/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface App42LoginViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *loginBackgroundImage;
@property (strong, nonatomic) IBOutlet UIScrollView *loginScrollView;
@property (strong, nonatomic) IBOutlet UIView *scrollContentView;
@property (strong, nonatomic) IBOutlet UIImageView *illustrationImage;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UILabel *forgotPasswordLabel;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UILabel *signupLabel;

- (IBAction)loginButtonClick:(UIButton *)sender;
- (IBAction)cancelButton:(id)sender;

@end
