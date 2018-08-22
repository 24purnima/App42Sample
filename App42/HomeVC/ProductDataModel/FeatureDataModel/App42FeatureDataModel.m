//
//  App42FeatureDataModel.m
//  App42
//
//  Created by Purnima Singh on 27/06/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import "App42FeatureDataModel.h"

@interface App42FeatureDataModel (JSONConversion)
- (NSDictionary *)JSONDictionary;
@end


@implementation App42FeatureDataModel

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
                                                    @"description": @"theDescription",
                                                    @"name": @"name",
                                                    };
}

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
{
    return dict ? [[App42FeatureDataModel alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(nullable id)value forKey:(NSString *)key
{
    id resolved = App42FeatureDataModel.properties[key];
    if (resolved) [super setValue:value forKey:resolved];
}

- (NSDictionary *)JSONDictionary
{
    id dict = [[self dictionaryWithValuesForKeys:App42FeatureDataModel.properties.allValues] mutableCopy];
    
    // Rewrite property names that differ in JSON
    for (id jsonName in App42FeatureDataModel.properties) {
        id propertyName = App42FeatureDataModel.properties[jsonName];
        if (![jsonName isEqualToString:propertyName]) {
            dict[jsonName] = dict[propertyName];
            [dict removeObjectForKey:propertyName];
        }
    }
    
    return dict;
}

@end
