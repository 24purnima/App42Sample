//
//  App42CustomerSupportViewController.m
//  App42
//
//  Created by Purnima Singh on 15/06/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import "App42CustomerSupportViewController.h"
#import "UIColor+UIColor_HexValue.h"
#import "App42ChatViewController.h"

@interface App42CustomerSupportViewController ()

@property (nonatomic, strong) NSArray *supportArray;

@end

@implementation App42CustomerSupportViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Customer Support";
    
    self.callusButton.layer.masksToBounds = true;
    self.callusButton.layer.cornerRadius = 5.0;
    
    self.chatWithusButton.layer.masksToBounds = true;
    self.chatWithusButton.layer.cornerRadius = 5.0;
    self.chatWithusButton.layer.borderColor = [UIColor colorFromHexString:@"#0433FF"].CGColor;
    self.chatWithusButton.layer.borderWidth = 1.0;
    
    _supportArray = [NSArray arrayWithObjects:@"Payment/Refund", @"Offers, Discount, Coupons", @"Manage your accounts", @"Others", nil];

    self.supportTable.dataSource = self;
    self.supportTable.delegate = self;
    self.supportTable.tableFooterView = [[UIView alloc] init];
    
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





- (IBAction)callusBtnClick:(id)sender {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:@"tel:12125551212"];
    [application openURL:URL options:@{} completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Opened url");
        }
    }];
}

- (IBAction)chatWithusBtnClick:(id)sender {
    App42ChatViewController *chatVC = [self.storyboard instantiateViewControllerWithIdentifier:@"App42ChatViewController"];
    chatVC.isCustomerSupport = true;
    [self.navigationController pushViewController:chatVC animated:true];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Queries related to your experience";
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"supportCell" forIndexPath:indexPath];
    cell.textLabel.text = _supportArray[indexPath.row];
    cell.textLabel.textColor = [UIColor grayColor];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _supportArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

@end
