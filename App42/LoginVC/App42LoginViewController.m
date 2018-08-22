//
//  App42LoginViewController.m
//  App42
//
//  Created by Purnima Singh on 15/06/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import "App42LoginViewController.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "App42CoreDataHandler.h"
#import "App42Constant.h"
#import "App42HomeViewController.h"
#import "App42MenuViewController.h"
#import "MBProgressHUD.h"

@interface App42LoginViewController ()
{
    UserService *userService;
}
@end

@implementation App42LoginViewController

-(void)createMenuView {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    App42MenuViewController *leftViewController = [storyboard instantiateViewControllerWithIdentifier:@"App42MenuViewController"];
    
    
    [SlideNavigationController sharedInstance].leftMenu = leftViewController;
    [SlideNavigationController sharedInstance].menuRevealAnimationDuration = .18;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidClose object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *menu = note.userInfo[@"menu"];
        NSLog(@"Closed %@", menu);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidOpen object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *menu = note.userInfo[@"menu"];
        NSLog(@"Opened %@", menu);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidReveal object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *menu = note.userInfo[@"menu"];
        NSLog(@"Revealed %@", menu);
    }];
}

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

    CGFloat textFieldHeight = self.emailTextField.frame.size.height;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, textFieldHeight)];
    self.emailTextField.leftView = paddingView;
    self.emailTextField.leftViewMode = UITextFieldViewModeAlways;
    self.emailTextField.delegate = self;
    
    UIView *passPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, textFieldHeight)];
    self.passwordTextField.leftView = passPaddingView;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.delegate = self;
    
    userService = [App42API buildUserService];
    
//    [self createMenuView];
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


- (IBAction)loginButtonClick:(UIButton *)sender {
    NSString *username = [self.emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (!(username.length > 0)) {
        [self showAlertView:@"Alert!" message:@"Enter Valid Name"];
    }
    else if (!(password.length > 0)) {
        [self showAlertView:@"Alert!" message:@"Enter Valid Password"];
    }
    else {
        
        NSMutableDictionary *otherMetaHeaders = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"true",@"userProfile", nil];
        [userService setOtherMetaHeaders:otherMetaHeaders];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [userService authenticateUser:username password:password completionBlock:^(BOOL success, id responseObj, App42Exception *exception)  {
            if (success)      {
                User *user = (User*)responseObj;
                NSLog(@"userName is %@" , user.userName);
                NSLog(@"sessionId is %@" ,  user.sessionId);
                NSLog(@"mobile number: %@", user.profile.mobile);
                NSString *mobileStr = [NSString stringWithFormat:@"%@", user.profile.mobile];
                
                BOOL isLoginDataSave = [App42CoreDataHandler saveLoginData:kLoginEntityName username:user.userName accountlocked:user.accountLocked sessionid:user.sessionId email:user.email mobile:mobileStr];
                if (isLoginDataSave) {
                    NSLog(@"login data saved");
                }
                
                [self performSegueWithIdentifier:@"productPage" sender:self];

                
                
            }
            else      {
                NSLog(@"Exception is %@",[exception reason]);
                NSLog(@"HTTP error Code is %d",[exception httpErrorCode]);
                NSLog(@"App Error Code is %d",[exception appErrorCode]);
                NSLog(@"User Info is %@",[exception userInfo]);
                
                [self showAlertView:[[exception userInfo] objectForKey:@"message"] message:[[exception userInfo] objectForKey:@"details"]];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES]; //hide that after your Dela Loading finished fromDatabase                
            });
        }];
        
        
        
        
        
        
        
//        [userService authenticateUser:username password:password completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
//            if (success)      {
//                User *user = (User*)responseObj;
//                NSLog(@"userName is %@" , user.userName);
//                NSLog(@"sessionId is %@" ,  user.sessionId);
//                NSLog(@"mobile number: %@", user.profile.mobile);
//                NSString *mobileStr = [NSString stringWithFormat:@"%@", user.profile.mobile];
//                
//
//                BOOL isLoginDataSave = [App42CoreDataHandler saveLoginData:kLoginEntityName username:user.userName accountlocked:user.accountLocked sessionid:user.sessionId email:user.email mobile:mobileStr];
//                if (isLoginDataSave) {
//                    NSLog(@"login data saved");
//                }
//                
//                [self performSegueWithIdentifier:@"productPage" sender:self];
//            }
//            else
//            {
//                NSLog(@"Exception is %@",[exception reason]);
//                NSLog(@"HTTP error Code is %d",[exception httpErrorCode]);
//                NSLog(@"App Error Code is %d",[exception appErrorCode]);
//                NSLog(@"User Info is %@",[exception userInfo]);
//                
//                [self showAlertView:[[exception userInfo] objectForKey:@"message"] message:[[exception userInfo] objectForKey:@"details"]];
//                
//            }
//        }];
    }
}

- (IBAction)cancelButton:(id)sender {
    [self.navigationController dismissViewControllerAnimated:true completion:^{}];
}



- (void)keyboardWasShown:(NSNotification *)notification {
    
    NSDictionary* info = [notification userInfo];
    
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    if (keyboardSize.height) {
        [self.loginScrollView setContentInset:UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)];
    }
    
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {    
    [self.loginScrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.emailTextField]) {
        [self.passwordTextField becomeFirstResponder];
    }
    else if([textField isEqual:self.passwordTextField]) {
        [self.passwordTextField resignFirstResponder];
    }
    return true;
}

-(BOOL)validateEmail:(NSString *)candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    NSLog(@"email: %d", [emailTest evaluateWithObject:candidate]);
    
    return [emailTest evaluateWithObject:candidate];
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

-(void)gotohomepage {
    
}

@end
