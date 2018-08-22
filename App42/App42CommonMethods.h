//
//  App42CommonMethods.h
//  App42
//
//  Created by Purnima Singh on 20/07/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "App42ModelDataModel.h"
@interface App42CommonMethods : NSObject

+(void)setMACredentials;
+(void)setCloudAPICredentials;
+(void)addOrUpdatePreference:(App42ModelDataModel *)model;
+(NSString *)convertStringToHashCode:(NSString *)userId;
+(NSMutableArray *)getAllWishlistData;
+(NSInteger)getAllWishlistCount;
+(NSInteger)getAllCartCount;

@end
