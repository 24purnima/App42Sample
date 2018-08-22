//
//  App42CongratulationViewController.m
//  App42
//
//  Created by Purnima Singh on 04/07/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import "App42CongratulationViewController.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "App42CoreDataHandler.h"
#import "App42Constant.h"

@interface App42CongratulationViewController ()

@end

@implementation App42CongratulationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.amountlabel.text = [NSString stringWithFormat:@"Rs. %d", self.amountValue];
    [self getLoyaltyPoints];
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

-(void)getLoyaltyPoints {
    LoyaltyService *loyaltyService = [App42API buildLoyaltyService];
    [loyaltyService getUserById:[App42API getLoggedInUser] completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success) {
            Loyalty *storage = (Loyalty*)responseObj;
            NSLog(@"dbName is %@" , storage.dbName);
            NSLog(@"collectionNameId is %@" ,  storage.collectionName);
            NSMutableArray *jsonDocArray = storage.jsonDocArray;
            for(JSONDocument *jsonDoc in jsonDocArray)
            {
                id loyaltyJson = [jsonDoc.jsonDoc JSONValue];
                
                BOOL isDataSave = [App42CoreDataHandler saveLoyaltyData:kLoyaltyEntityName totalPoints:[[loyaltyJson objectForKey:kTotalPointsAttribute] integerValue] earnPoints:[[loyaltyJson objectForKey:kEarnPointsAttribute] integerValue] redeemPoints:[[loyaltyJson objectForKey:kRedeemPointsAttribute] integerValue] userName:[loyaltyJson objectForKey:kUserNameAttribute] userId:[loyaltyJson objectForKey:kUserIdAttribute]];
                
                if (isDataSave) {
                    NSLog(@"loyalty data saved successfully");
                }
            }
        }
        else {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
        }
    }];

}

- (IBAction)continueBtnClick:(id)sender {    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(popupClose)]) {
        [self.delegate popupClose];
    }
}
@end
