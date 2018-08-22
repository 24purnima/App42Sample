//
//  App42CoreDataHandler.h
//  App42
//
//  Created by Purnima Singh on 13/07/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "App42ModelDataModel.h"

@interface App42CoreDataHandler : NSObject

+(BOOL)saveDataTotheEntity:(NSString *)entityName modelData:(App42ModelDataModel *)saveModel;
+(BOOL)deleteData:(NSString *)entityName index:(NSUInteger)arrIndex;

+(BOOL)saveLoginData:(NSString *)entityName username:(NSString *)userName accountlocked:(BOOL)accountLocked sessionid:(NSString *)sessionID email:(NSString *)email mobile:(NSString *)mobile;
+(BOOL)deleteAllSavedDataFromEntity:(NSString *)nameEntity;

+(BOOL)saveLoyaltyData:(NSString *)entityName totalPoints:(NSInteger)totalPoints earnPoints:(NSInteger)earnPoints redeemPoints:(NSInteger)redeemPoints userName:(NSString *)userName userId:(NSString *)userId;

+(BOOL)deleteCoreDataUsingModelId:(NSInteger)modelId entityname:(NSString *)entityName;

@end
