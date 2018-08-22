//
//  UIColor+UIColor_HexValue.m
//  App42
//
//  Created by Purnima Singh on 28/06/18.
//  Copyright © 2018 Purnima Singh. All rights reserved.
//

#import "UIColor+UIColor_HexValue.h"

@implementation UIColor (UIColor_HexValue)

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
