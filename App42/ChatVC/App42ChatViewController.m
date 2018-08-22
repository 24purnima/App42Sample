//
//  App42ChatViewController.m
//  App42
//
//  Created by Purnima Singh on 15/06/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import "App42ChatViewController.h"

@interface App42ChatViewController ()

@end

@implementation App42ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Chat with us";
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
    if (self.isCustomerSupport == true)
        return NO;
    else
        return YES;
}


@end
