//
//  LoyaltyService.h
//  Shephertz_App42_iOS_API
//
//  Created by Purnima Singh on 18/07/18.
//  Copyright © 2018 ShephertzTechnology PVT LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "App42Service.h"

@interface LoyaltyService : App42Service

+(instancetype)sharedInstanceWithAPIKey:(NSString *)apiKey  secretKey:(NSString *)secretKey;
+(void)terminate;

-(id)initWithAPIKey:(NSString *)apiKey  secretKey:(NSString *)secretKey;
-(void)purchase:(NSDictionary *)params completionBlock:(App42ResponseBlock)completionBlock;
-(void)redeem:(NSDictionary *)params completionBlock:(App42ResponseBlock)completionBlock;
-(void)getCatalogueProducts:(App42ResponseBlock)completionBlock;
-(void)getCatalogueByProdcutID:(NSString *)productId completionBlock:(App42ResponseBlock)completionBlock;
-(void)getUserById:(NSString *)userId completionBlock:(App42ResponseBlock)completionBlock;
-(void)getTransactionHistoryByUserID:(NSString *)userId completionBlock:(App42ResponseBlock)completionBlock;
@end
