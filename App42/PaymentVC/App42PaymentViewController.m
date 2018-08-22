//
//  App42PaymentViewController.m
//  App42
//
//  Created by Purnima Singh on 15/06/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import "App42PaymentViewController.h"
#import "AppDelegate.h"
#import "UIColor+UIColor_HexValue.h"
#import "App42HomeViewController.h"
#import "App42CongratulationViewController.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "App42Constant.h"
#import "App42CoreDataHandler.h"
#import "MBProgressHUD.h"

#define viewBorderColor @"#28D9CE"

@interface App42PaymentViewController ()
{
    int totalAmountValue;
}
@property (nonatomic, strong) NSMutableArray *orderArray;

@end

@implementation App42PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Payment";

    self.netBankingView.layer.borderWidth = 1.0;
    self.netBankingView.layer.borderColor = [UIColor colorFromHexString:viewBorderColor].CGColor;
    self.netBankingView.layer.cornerRadius = 5;
    self.netBankingView.layer.masksToBounds = true;
    self.netBankingView.backgroundColor = [UIColor clearColor];
    
    self.creditCardView.layer.borderWidth = 1.0;
    self.creditCardView.layer.borderColor = [UIColor colorFromHexString:viewBorderColor].CGColor;
    self.creditCardView.layer.cornerRadius = 5;
    self.creditCardView.layer.masksToBounds = true;
    self.creditCardView.backgroundColor = [UIColor clearColor];
    
    self.loyaltyPointsView.layer.borderWidth = 1.0;
    self.loyaltyPointsView.layer.borderColor = [UIColor colorFromHexString:viewBorderColor].CGColor;
    self.loyaltyPointsView.layer.cornerRadius = 5;
    self.loyaltyPointsView.layer.masksToBounds = true;
    self.loyaltyPointsView.backgroundColor = [UIColor clearColor];
    
    self.addNewPaymentView.layer.borderWidth = 1.0;
    self.addNewPaymentView.layer.borderColor = [UIColor colorFromHexString:viewBorderColor].CGColor;
    self.addNewPaymentView.layer.cornerRadius = 5;
    self.addNewPaymentView.layer.masksToBounds = true;
    self.addNewPaymentView.backgroundColor = [UIColor clearColor];
    
//    self.placeOrderButton.layer.cornerRadius = 5;
//    self.placeOrderButton.layer.masksToBounds = true;
    
    
    
    self.orderArray = [[NSMutableArray alloc] init];
    
    NSManagedObjectContext *context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:kAddToCartEntityName];
    self.orderArray = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSLog(@"orderArray : %@", self.orderArray);
    
    totalAmountValue = 0;
    
    for (NSManagedObject *obj in self.orderArray) {
        totalAmountValue += [[obj valueForKey:kAmountAttribute] intValue];
    }
   
    self.totalAmountLabel.text = [NSString stringWithFormat:@"%d", totalAmountValue];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"congoView"]) {
        App42CongratulationViewController *vc = segue.destinationViewController;
        vc.delegate = self;
        vc.amountValue = totalAmountValue;
        
    }
}


- (IBAction)placeOrderBtnClick:(id)sender {
    
    long long milliseconds = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);

    NSMutableArray *prodArray = [NSMutableArray new];
    for (NSManagedObject *prodObj in self.orderArray) {
        NSMutableDictionary *prodDict = [NSMutableDictionary new];
        [prodDict setObject:[prodObj valueForKey:kNameAttribute] forKey:@"productName"];
        [prodDict setObject:[prodObj valueForKey:kModelIDAttribute] forKey:@"productId"];
        [prodDict setObject:@(1) forKey:@"quantity"];
        [prodArray addObject:prodDict];
    }
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:prodArray forKey:@"products"];
    [param setObject:@(totalAmountValue) forKey:@"totalAmount"];
    [param setObject:[App42API getLoggedInUser] forKey:@"userId"];
    [param setObject:[App42API getLoggedInUser] forKey:@"userName"];
    [param setObject:@(milliseconds) forKey:@"orderID"];
    [param setObject:@"reward" forKey:@"type"];
    
    NSLog(@"param: %@", param);
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];  //Activity Indicator loading
    
    LoyaltyService *loyaltyService = [App42API buildLoyaltyService];
    [loyaltyService purchase:param completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success) {
            
            BOOL isDataDelete = [App42CoreDataHandler deleteAllSavedDataFromEntity:kAddToCartEntityName];
            if (isDataDelete) {
                NSLog(@"all data deleted successfully");
            }
            
            App42Response *app42Response = (App42Response*)responseObj;
            NSLog(@"Response is %@" , app42Response.strResponse);
            NSLog(@"isResponseSuccess is %d" , app42Response.isResponseSuccess);
            
            [self performSegueWithIdentifier:@"congoView" sender:self];
        }
        else {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES]; //hide that after your Dela Loading finished fromDatabase
        });
    }];
    
}

-(void)popupClose {
    [self.navigationController dismissViewControllerAnimated:true completion:^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBadgeNumber" object:nil];
        
        [[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:YES];
    }];
}


@end
