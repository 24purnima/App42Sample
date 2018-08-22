//
//  App42CommonMethods.m
//  App42
//
//  Created by Purnima Singh on 20/07/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import "App42CommonMethods.h"
#import "App42Constant.h"
#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>
#import "NSString+MD5.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "App42ProductDataModel.h"
#import "App42ModelDataModel.h"

@implementation App42CommonMethods


+(void)setMACredentials {
    [App42API initializeWithAPIKey:kApp42APIKey_US andSecretKey:kApp42SecretKey_US];
    [App42API setBaseUrl:kApp42BaseUrl_US];
}

+(void)setCloudAPICredentials {
    [App42API initializeWithAPIKey:kApp42APIKey_India andSecretKey:kApp42SecretKey_India];
    [App42API setBaseUrl:kApp42BaseUrl_India];
}

+(void)addOrUpdatePreference:(App42ModelDataModel *)model {
    [App42CommonMethods setMACredentials];
    
    NSMutableArray *preferenceArray = [NSMutableArray new];
    PreferenceData *prefData = [[PreferenceData alloc] init];
    prefData.userId = [App42CommonMethods convertStringToHashCode:[App42API getLoggedInUser]];
    prefData.itemId = [NSString stringWithFormat:@"%d", model.modelID];
    prefData.preference = @"1";
    [preferenceArray addObject:prefData];
    
    RecommenderService *recommendService = [App42API buildRecommenderService];
    [recommendService addOrUpdatePreference:preferenceArray completionBlock:^(BOOL success, id responseObj, App42Exception *exception) {
        if (success)      {
            App42Response *response = (App42Response*)responseObj;
            NSString *success = response.strResponse;
            NSString *jsonResponse = [response toString];
            NSLog(@"json response: %@", jsonResponse);
        }
        else      {
            NSLog(@"Exception = %@",[exception reason]);
            NSLog(@"HTTP error Code = %d",[exception httpErrorCode]);
            NSLog(@"App Error Code = %d",[exception appErrorCode]);
            NSLog(@"User Info = %@",[exception userInfo]);
        }
        [App42CommonMethods setCloudAPICredentials];
    }];
}

+(NSString *)convertStringToHashCode:(NSString *)userId {
    NSString *userstr = [NSString stringWithFormat:@"%d",[userId javaHashCode]];
    userstr = [[userstr stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return userstr;
}

+(NSMutableArray *)getAllWishlistData {
    NSMutableArray *wishlistArray = [[NSMutableArray alloc] init];
    
    NSManagedObjectContext *context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:kWishlistEntityName];
    wishlistArray = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return wishlistArray;
}

+(NSInteger)getAllWishlistCount {
    NSMutableArray *wishlistArray = [[NSMutableArray alloc] init];
    
    NSManagedObjectContext *context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:kWishlistEntityName];
    wishlistArray = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return wishlistArray.count;
}

+(NSInteger)getAllCartCount {
    NSMutableArray *cartArray = [[NSMutableArray alloc] init];
    
    NSManagedObjectContext *context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:kAddToCartEntityName];
    cartArray = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return cartArray.count;
}

@end
