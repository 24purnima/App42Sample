//
//  App42ModelDataModel.m
//  App42
//
//  Created by Purnima Singh on 27/06/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import "App42ModelDataModel.h"

// Shorthand for simple blocks
#define λ(decl, expr) (^(decl) { return (expr); })

// nil → NSNull conversion for JSON dictionaries
static id NSNullify(id _Nullable x) {
    return (x == nil || x == NSNull.null) ? NSNull.null : x;
}

static id map(id collection, id (^f)(id value)) {
    id result = nil;
    if ([collection isKindOfClass:NSArray.class]) {
        result = [NSMutableArray arrayWithCapacity:[collection count]];
        for (id x in collection) [result addObject:f(x)];
    } else if ([collection isKindOfClass:NSDictionary.class]) {
        result = [NSMutableDictionary dictionaryWithCapacity:[collection count]];
        for (id key in collection) [result setObject:f([collection objectForKey:key]) forKey:key];
    }
    return result;
}


@interface App42ModelDataModel (JSONConversion)

- (NSDictionary *)JSONDictionary;

@end


@implementation App42ModelDataModel
+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
                                                    @"amount": @"amount",
                                                    @"model_id": @"modelID",
                                                    @"img_urls": @"imgUrls",
                                                    @"icon_url": @"iconURL",
                                                    @"description": @"theDescription",
                                                    @"features": @"features",
                                                    @"name": @"name",
                                                    @"benefits": @"benefits",
                                                    @"isWishlist": @"isWislist",
                                                    };
}

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
{
    return dict ? [[App42ModelDataModel alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        _features = map(_features, λ(id x, [App42FeatureDataModel fromJSONDictionary:x]));
        _benefits = map(_benefits, λ(id x, [App42FeatureDataModel fromJSONDictionary:x]));
    }
    return self;
}

- (void)setValue:(nullable id)value forKey:(NSString *)key
{
    id resolved = App42ModelDataModel.properties[key];
    if (resolved) [super setValue:value forKey:resolved];
}

- (NSDictionary *)JSONDictionary
{
    id dict = [[self dictionaryWithValuesForKeys:App42ModelDataModel.properties.allValues] mutableCopy];
    
    // Rewrite property names that differ in JSON
    for (id jsonName in App42ModelDataModel.properties) {
        id propertyName = App42ModelDataModel.properties[jsonName];
        if (![jsonName isEqualToString:propertyName]) {
            dict[jsonName] = dict[propertyName];
            [dict removeObjectForKey:propertyName];
        }
    }
    
    // Map values that need translation
    [dict addEntriesFromDictionary:@{
                                     @"features": map(_features, λ(id x, [x JSONDictionary])),
                                     @"benefits": NSNullify(map(_benefits, λ(id x, [x JSONDictionary]))),
                                     }];
    
    return dict;
}
@end
