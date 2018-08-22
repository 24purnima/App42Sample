//
//  App42FeatureDataModel.h
//  App42
//
//  Created by Purnima Singh on 27/06/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface App42FeatureDataModel : NSObject

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;

@property (nonatomic, copy) NSString *theDescription;
@property (nonatomic, copy) NSString *name;

@end
