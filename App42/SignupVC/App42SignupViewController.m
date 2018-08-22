//
//  App42SignupViewController.m
//  App42
//
//  Created by Purnima Singh on 15/06/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import "App42SignupViewController.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "App42CoreDataHandler.h"
#import "App42Constant.h"

@interface App42SignupViewController ()
{
    UserService *userService;
}


@end

@implementation App42SignupViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self registerForKeyboardNotifications];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [self deregisterFromKeyboardNotifications];
    
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    CGFloat textFieldHeight = self.nameTextField.frame.size.height;
    
    UIView *namePaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, textFieldHeight)];
    self.nameTextField.leftView = namePaddingView;
    self.nameTextField.leftViewMode = UITextFieldViewModeAlways;
    self.nameTextField.delegate = self;
    
    UIView *emailPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, textFieldHeight)];
    self.emailTextField.leftView = emailPaddingView;
    self.emailTextField.leftViewMode = UITextFieldViewModeAlways;
    self.emailTextField.delegate = self;
    
    UIView *mobilePaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, textFieldHeight)];
    self.mobileTextField.leftView = mobilePaddingView;
    self.mobileTextField.leftViewMode = UITextFieldViewModeAlways;
    self.mobileTextField.delegate = self;
    
    UIView *passPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, textFieldHeight)];
    self.passwordTextField.leftView = passPaddingView;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.delegate = self;
    
    UIView *retypepassPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, textFieldHeight)];
    self.retypeTextField.leftView = retypepassPaddingView;
    self.retypeTextField.leftViewMode = UITextFieldViewModeAlways;
    self.retypeTextField.delegate = self;
    
    userService = [App42API buildUserService];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)cancelButtonClicked:(id)sender {
    [self.navigationController dismissViewControllerAnimated:true completion:^{}];
}

- (IBAction)signUpButtonClicked:(id)sender {
    
    NSString *username = [self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email = [self.emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *mobile = [self.mobileTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *retypePassword = [self.retypeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (!(username.length > 0)) {
        [self showAlertView:@"Alert!" message:@"Enter Valid Name"];
    }
    else if (![self validateEmail:email]) {
        [self showAlertView:@"Alert!" message:@"Enter Valid Email Id"];
    }
    else if (![self validatePhoneNumber:mobile]) {
        [self showAlertView:@"Alert!" message:@"Enter Valid Phone Number"];
    }
    else if (!(password.length > 0)) {
        [self showAlertView:@"Alert!" message:@"Enter Valid Password"];
    }
    else if (!(retypePassword == password)) {
        [self showAlertView:@"Alert!" message:@"Password does not match with previous password"];
    }
    else {
        NSLog(@"name: %@ \nemail: %@\n mobile: %@\npassword: %@\nretypepassword: %@", username, email, mobile, password, retypePassword);
        
        Profile *profile = [[Profile alloc] init];
        profile.mobile = mobile;
        
        [userService createUserWithProfile:username password:password emailAddress:email profile:profile completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
             if (success)      {
                 User *user = (User*)responseObj;
                 NSLog(@"userName is %@" , user.userName);
                 NSLog(@"emailId is %@" ,  user.email);
                 NSLog(@"mobile number: %@", user.profile.mobile);
//                 NSString *jsonResponse = [user toString];
//                 NSLog(@"json response: %@", jsonResponse);
                 
                 BOOL isLoginDataSave = [App42CoreDataHandler saveLoginData:kLoginEntityName username:user.userName accountlocked:user.accountLocked sessionid:user.sessionId email:user.email mobile:user.profile.mobile];
                 if (isLoginDataSave) {
                     NSLog(@"login data saved");
                 }
                 
                 [self performSegueWithIdentifier:@"signupProductPage" sender:self];
             }
             else
             {
                 NSLog(@"Exception is %@",[exception reason]);
                 NSLog(@"HTTP error Code is %d",[exception httpErrorCode]);
                 NSLog(@"App Error Code is %d",[exception appErrorCode]);
                 NSLog(@"User Info is %@",[exception userInfo]);
                 
                 [self showAlertView:[[exception userInfo] objectForKey:@"message"] message:[[exception userInfo] objectForKey:@"details"]];
             }
        }];
    }
}


- (void)keyboardWasShown:(NSNotification *)notification {
    
    NSDictionary* info = [notification userInfo];
    
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    if (keyboardSize.height) {
        [self.signupScrollView setContentInset:UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)];
    }
    
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    [self.signupScrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.nameTextField]) {
        [self.emailTextField becomeFirstResponder];
    }
    else if([textField isEqual:self.emailTextField]) {
        [self.mobileTextField becomeFirstResponder];
    }
    else if ([textField isEqual:self.mobileTextField]) {
        [self.passwordTextField becomeFirstResponder];
    }
    else if ([textField isEqual:self.passwordTextField]) {
        [self.retypeTextField becomeFirstResponder];
    }
    else {
        [self.retypeTextField resignFirstResponder];
    }
    return true;
}


- (void)registerForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)deregisterFromKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
}

-(BOOL)validateEmail:(NSString *)candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    NSLog(@"email: %d", [emailTest evaluateWithObject:candidate]);

    return [emailTest evaluateWithObject:candidate];
}

-(BOOL)validatePhoneNumber:(NSString *)phone {
    NSString *phoneRegex = @"[0-9]{10}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    BOOL phoneValidates = [phoneTest evaluateWithObject:phone];
    NSLog(@"phoneValidates: %d", phoneValidates);
    return phoneValidates;
}

-(void)showAlertView:(NSString *)title message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        // Ok action example
        NSLog(@"ok clicked");
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
