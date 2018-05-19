//
//  UILabel+SRFontAdjust.m
//  SRFont
//
//  Created by hlet on 2018/5/17.
//  Copyright © 2018年 hlet. All rights reserved.
//

#import "UILabel+SRFontAdjust.h"
#import "ChangeSelector.h"
#import <objc/runtime.h>
#import "SRFontAdjust.h"

@implementation UILabel (SRFontAdjust)
+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [ChangeSelector exchangeInstanceMethodWithClass:[self class] originalSelector:@selector(awakeFromNib) swizzledSelector:@selector(srAwakeFromNib)];
        [ChangeSelector exchangeInstanceMethodWithClass:[self class] originalSelector:@selector(didMoveToSuperview) swizzledSelector:@selector(srDidMoveToSuperview)];
        [ChangeSelector exchangeInstanceMethodWithClass:[self class] originalSelector:@selector(removeFromSuperview) swizzledSelector:@selector(srRemoveFromSuperview)];
        [ChangeSelector exchangeInstanceMethodWithClass:[self class] originalSelector:@selector(setFont:) swizzledSelector:@selector(setSRFont:)];
    });
}

- (void)srDidMoveToSuperview{
    [self srDidMoveToSuperview];
    if (![NSStringFromClass([self.superview class]) isEqualToString:@"_UINavigationBarContentView"] && ![NSStringFromClass([self.superview class]) isEqualToString:@"_UIModernBarButton"]) {
        if (self.isAddCheck == NO) {
            self.isAddCheck = YES;
            [[SRFontAdjust single] addObserver:self forKeyPath:@"fontMultiple" options:NSKeyValueObservingOptionNew context:nil];
        }
    }
}

- (void)srRemoveFromSuperview{
    [self srRemoveFromSuperview];
    if (![NSStringFromClass([self.superview class]) isEqualToString:@"_UINavigationBarContentView"] && ![NSStringFromClass([self.superview class]) isEqualToString:@"_UIModernBarButton"]) {
        if (self.isAddCheck == YES) {
            [[SRFontAdjust single] removeObserver:self forKeyPath:@"fontMultiple"];
            self.isAddCheck = NO;
            self.originalFont = nil;
        }
    }
}

- (void)srAwakeFromNib{
    [self srAwakeFromNib];
    [self setFont:[UIFont fontWithName:self.font.fontName size:self.font.pointSize]];
}

- (void)setSRFont:(UIFont *)font{
    [self setSRFont:font];
    if (self.isAdjust == NO) {
        self.originalFont = [UIFont fontWithName:font.fontName size:(font.pointSize-([SRFontAdjust single].fontMultiple*2))];
    }else{
        self.isAdjust = NO;
    }
}

- (void)setOriginalFont:(UIFont *)originalFont{
    objc_setAssociatedObject(self, @selector(originalFont), originalFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIFont *)originalFont{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setIsAddCheck:(BOOL)isAddCheck{
    objc_setAssociatedObject(self, @selector(isAddCheck), @(isAddCheck), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isAddCheck{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setIsAdjust:(BOOL)isAdjust{
    objc_setAssociatedObject(self, @selector(isAdjust), @(isAdjust), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isAdjust{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"fontMultiple"]) {
        self.isAdjust = YES;
        self.font = [UIFont fontWithName:self.originalFont.fontName size:self.originalFont.pointSize];
    }
}

@end
