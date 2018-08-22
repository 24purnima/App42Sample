//
//  App42ProfileViewController.m
//  App42
//
//  Created by Purnima Singh on 04/07/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import "App42ProfileViewController.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "AppDelegate.h"
#import "App42Constant.h"

@interface App42ProfileViewController ()

@end

@implementation App42ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Profile";
//    self.userNameLabel.text = [App42API getLoggedInUser];
    
    
    
    self.pointsCount.text = [NSString stringWithFormat:@"0\nLoaylty Points"];
    self.notificationCount.text = [NSString stringWithFormat:@"0\nNotifications"];
    self.mobileLabel.text = [NSString stringWithFormat:@"No contact number found!"];
    
    NSManagedObjectContext *context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:kLoginEntityName];
    NSArray *userArray = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSLog(@"userArray: %@", userArray);
    
    for (NSManagedObject *obj in userArray) {
        self.emailLabel.text = [obj valueForKey:kEmailAttribute];
        self.userNameLabel.text = [obj valueForKey:kUserNameAttribute];
        if ([obj valueForKey:kMobileAttribute]) {
            self.mobileLabel.text = [obj valueForKey:kMobileAttribute];
        }
    }
    
    NSManagedObjectContext *loyalcontext = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    NSFetchRequest *loyaltyRequest = [[NSFetchRequest alloc] initWithEntityName:kLoyaltyEntityName];
    NSArray *loyalArray = [[loyalcontext executeFetchRequest:loyaltyRequest error:nil] mutableCopy];
    for (NSManagedObject *loyalObj in loyalArray) {
        if ([[loyalObj valueForKey:kUserNameAttribute] isEqualToString:[App42API getLoggedInUser]]) {
            NSLog(@"%@", [loyalObj valueForKey:kTotalPointsAttribute]);
            self.pointsCount.text = [NSString stringWithFormat:@"%@\nLoaylty Points", [loyalObj valueForKey:kTotalPointsAttribute]] ;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}
@end
