//
//  App42ProductDataModel.h
//  App42
//
//  Created by Purnima Singh on 27/06/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "App42ModelDataModel.h"
@class App42ModelDataModel;

@interface App42ProductDataModel : NSObject

@property (nonatomic, copy)   NSArray<App42ModelDataModel *> *models;
@property (nonatomic, copy)   NSString *imgURL;
@property (nonatomic, copy)   NSString *cardColor;
@property (nonatomic, assign) NSInteger productID;
@property (nonatomic, copy)   NSString *theDescription;
@property (nonatomic, copy)   NSString *name;
@property (nonatomic, copy)   NSString *createdAt;

+ (_Nullable instancetype)fromJSON:(NSString *)json encoding:(NSStringEncoding)encoding error:(NSError *_Nullable *)error;
+ (_Nullable instancetype)fromData:(NSData *)data error:(NSError *_Nullable *)error;
- (NSString *_Nullable)toJSON:(NSStringEncoding)encoding error:(NSError *_Nullable *)error;
- (NSData *_Nullable)toData:(NSError *_Nullable *)error;


@end

