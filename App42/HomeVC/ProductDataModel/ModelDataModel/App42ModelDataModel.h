//
//  App42ModelDataModel.h
//  App42
//
//  Created by Purnima Singh on 27/06/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "App42FeatureDataModel.h"
@class App42FeatureDataModel;

@interface App42ModelDataModel : NSObject

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;

@property (nonatomic, assign)           BOOL isWishlist;
@property (nonatomic, copy)           NSString *amount;
@property (nonatomic, assign)         NSInteger modelID;
@property (nonatomic, copy)           NSArray<NSString *> *imgUrls;
@property (nonatomic, copy)           NSString *iconURL;
@property (nonatomic, copy)           NSString *theDescription;
@property (nonatomic, copy)           NSArray<App42FeatureDataModel *> *features;
@property (nonatomic, copy)           NSString *name;
@property (nonatomic, nullable, copy) NSArray<App42FeatureDataModel *> *benefits;

@end
