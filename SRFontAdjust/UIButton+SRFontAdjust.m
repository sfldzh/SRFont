//
//  UIButton+SRFontAdjust.m
//  SRFont
//
//  Created by hlet on 2018/5/17.
//  Copyright © 2018年 hlet. All rights reserved.
//

#import "UIButton+SRFontAdjust.h"
#import "ChangeSelector.h"

@implementation UIButton (SRFontAdjust)
+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [ChangeSelector exchangeInstanceMethodWithClass:[self class] originalSelector:@selector(awakeFromNib) swizzledSelector:@selector(srAwakeFromNib)];
        [ChangeSelector exchangeInstanceMethodWithClass:[self class] originalSelector:@selector(didMoveToSuperview) swizzledSelector:@selector(srDidMoveToSuperview)];
    });
}

- (void)srDidMoveToSuperview{
    [self srDidMoveToSuperview];
}


- (void)srAwakeFromNib{
    [self srAwakeFromNib];
    [self.titleLabel setFont:[UIFont fontWithName:self.titleLabel.font.fontName size:self.titleLabel.font.pointSize]];
}

@end
