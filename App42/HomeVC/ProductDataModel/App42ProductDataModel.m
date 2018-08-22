//
//  App42ProductDataModel.m
//  App42
//
//  Created by Purnima Singh on 27/06/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import "App42ProductDataModel.h"

// Shorthand for simple blocks
#define λ(decl, expr) (^(decl) { return (expr); })


@interface App42ProductDataModel (JSONConversion)

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;

@end


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

#pragma mark - JSON serialization

App42ProductDataModel *_Nullable App42ProductFromData(NSData *data, NSError **error)
{
    @try {
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:error];
        return *error ? nil : [App42ProductDataModel fromJSONDictionary:json];
    } @catch (NSException *exception) {
        *error = [NSError errorWithDomain:@"JSONSerialization" code:-1 userInfo:@{ @"exception": exception }];
        return nil;
    }
}

App42ProductDataModel *_Nullable App42ProductFromJSON(NSString *json, NSStringEncoding encoding, NSError **error)
{
    return App42ProductFromData([json dataUsingEncoding:encoding], error);
}

NSData *_Nullable App42ProductToData(App42ProductDataModel *product, NSError **error)
{
    @try {
        id json = [product JSONDictionary];
        NSData *data = [NSJSONSerialization dataWithJSONObject:json options:kNilOptions error:error];
        return *error ? nil : data;
    } @catch (NSException *exception) {
        *error = [NSError errorWithDomain:@"JSONSerialization" code:-1 userInfo:@{ @"exception": exception }];
        return nil;
    }
}

NSString *_Nullable App42ProductToJSON(App42ProductDataModel *product, NSStringEncoding encoding, NSError **error)
{
    NSData *data = App42ProductToData(product, error);
    return data ? [[NSString alloc] initWithData:data encoding:encoding] : nil;
}

@implementation App42ProductDataModel

+ (NSDictionary<NSString *, NSString *> *)properties
{
    static NSDictionary<NSString *, NSString *> *properties;
    return properties = properties ? properties : @{
                                                    @"models": @"models",
                                                    @"product_id": @"productID",
                                                    @"created_at": @"createdAt",
                                                    @"img_url": @"imgURL",
                                                    @"description": @"theDescription",
                                                    @"name": @"name",
                                                    @"cardColor": @"cardColor",
                                                    };
}

+ (_Nullable instancetype)fromData:(NSData *)data error:(NSError *_Nullable *)error
{
    return App42ProductFromData(data, error);
}

+ (_Nullable instancetype)fromJSON:(NSString *)json encoding:(NSStringEncoding)encoding error:(NSError *_Nullable *)error
{
    return App42ProductFromJSON(json, encoding, error);
}

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
{
    return dict ? [[App42ProductDataModel alloc] initWithJSONDictionary:dict] : nil;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        _models = map(_models, λ(id x, [App42ModelDataModel fromJSONDictionary:x]));
    }
    return self;
}

- (void)setValue:(nullable id)value forKey:(NSString *)key
{
    id resolved = App42ProductDataModel.properties[key];
    if (resolved) [super setValue:value forKey:resolved];
}

- (NSDictionary *)JSONDictionary
{
    id dict = [[self dictionaryWithValuesForKeys:App42ProductDataModel.properties.allValues] mutableCopy];
    
    // Rewrite property names that differ in JSON
    for (id jsonName in App42ProductDataModel.properties) {
        id propertyName = App42ProductDataModel.properties[jsonName];
        if (![jsonName isEqualToString:propertyName]) {
            dict[jsonName] = dict[propertyName];
            [dict removeObjectForKey:propertyName];
        }
    }
    
    // Map values that need translation
    [dict addEntriesFromDictionary:@{
                                     @"models": map(_models, λ(id x, [x JSONDictionary])),
                                     }];
    
    return dict;
}

- (NSData *_Nullable)toData:(NSError *_Nullable *)error
{
    return App42ProductToData(self, error);
}

- (NSString *_Nullable)toJSON:(NSStringEncoding)encoding error:(NSError *_Nullable *)error
{
    return App42ProductToJSON(self, encoding, error);
}

@end
