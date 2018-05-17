//
//  UIFont+SRFontAdjust.m
//  SRFont
//
//  Created by hlet on 2018/5/17.
//  Copyright © 2018年 hlet. All rights reserved.
//

#import "UIFont+SRFontAdjust.h"
#import "ChangeSelector.h"
#import "SRFontAdjust.h"

@implementation UIFont (SRFontAdjust)
+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [ChangeSelector exchangeClassMethodWithClass:[self class] originalSelector:@selector(fontWithName:size:) swizzledSelector:@selector(srFontWithName:size:)];
        [ChangeSelector exchangeClassMethodWithClass:[self class] originalSelector:@selector(systemFontOfSize:) swizzledSelector:@selector(srSystemFontOfSize:)];
        [ChangeSelector exchangeClassMethodWithClass:[self class] originalSelector:@selector(boldSystemFontOfSize:) swizzledSelector:@selector(srBoldSystemFontOfSize:)];
        [ChangeSelector exchangeClassMethodWithClass:[self class] originalSelector:@selector(systemFontOfSize:weight:) swizzledSelector:@selector(srSystemFontOfSize:weight:)];
    });
}

+ (UIFont *)srFontWithName:(NSString *)fontName size:(CGFloat)fontSize{
    return [self srFontWithName:fontName size:[self getTransformationFontSize:fontSize]];
}

+ (UIFont *)srSystemFontOfSize:(CGFloat)fontSize{
    return [self srSystemFontOfSize:[self getTransformationFontSize:fontSize]];
}

+ (UIFont *)srBoldSystemFontOfSize:(CGFloat)fontSize{
    return [self srBoldSystemFontOfSize:[self getTransformationFontSize:fontSize]];
}

+ (UIFont *)srSystemFontOfSize:(CGFloat)fontSize weight:(UIFontWeight)weight{
    return [self srSystemFontOfSize:[self getTransformationFontSize:fontSize] weight:weight];
}


+ (CGFloat)getTransformationFontSize:(CGFloat)fontSize{
    CGFloat totleFontSize = [SRFontAdjust single].fontMultiple+fontSize;
    if (totleFontSize <= 0) {
        totleFontSize = 1;
    }
    return totleFontSize;
}

@end
