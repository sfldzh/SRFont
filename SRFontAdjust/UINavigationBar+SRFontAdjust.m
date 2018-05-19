//
//  UINavigationBar+SRFontAdjust.m
//  SRFont
//
//  Created by Danica on 2018/5/19.
//  Copyright © 2018年 hlet. All rights reserved.
//

#import "UINavigationBar+SRFontAdjust.h"
#import "ChangeSelector.h"
#import <objc/runtime.h>
#import "SRFontAdjust.h"

@implementation UINavigationBar (SRFontAdjust)
+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [ChangeSelector exchangeInstanceMethodWithClass:[self class] originalSelector:@selector(setTitleTextAttributes:) swizzledSelector:@selector(setSRTitleTextAttributes:)];
        [ChangeSelector exchangeInstanceMethodWithClass:[self class] originalSelector:@selector(didMoveToSuperview) swizzledSelector:@selector(srDidMoveToSuperview)];
        [ChangeSelector exchangeInstanceMethodWithClass:[self class] originalSelector:@selector(removeFromSuperview) swizzledSelector:@selector(srRemoveFromSuperview)];
    });
}

- (void)setSRTitleTextAttributes:(NSDictionary<NSAttributedStringKey, id> *)titleTextAttributes{
    [self setSRTitleTextAttributes:titleTextAttributes];
    if (self.isAdjust == NO) {
        UIFont *font = [titleTextAttributes objectForKey:NSFontAttributeName];
        if (font) {
            self.originalFont = font;
        }
        self.originalTitleTextAttributes = titleTextAttributes;
    }else{
        self.isAdjust = NO;
    }
}

- (void)srDidMoveToSuperview{
    [self srDidMoveToSuperview];
    if (self.isAddCheck == NO) {
        self.isAddCheck = YES;
        [[SRFontAdjust single] addObserver:self forKeyPath:@"fontMultiple" options:NSKeyValueObservingOptionNew context:nil];
        if (self.originalFont == nil) {
            self.originalFont = [UIFont boldSystemFontOfSize:17];
        }
    }
}

- (void)srRemoveFromSuperview{
    [self srRemoveFromSuperview];
    if (self.isAddCheck == YES) {
        [[SRFontAdjust single] removeObserver:self forKeyPath:@"fontMultiple"];
        self.isAddCheck = NO;
        self.originalTitleTextAttributes = nil;
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

- (void)setOriginalTitleTextAttributes:(NSDictionary *)originalTitleTextAttributes{
    objc_setAssociatedObject(self, @selector(originalTitleTextAttributes), originalTitleTextAttributes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)originalTitleTextAttributes{
    return objc_getAssociatedObject(self, _cmd);
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
        NSMutableDictionary *textAttributes;
        if (self.originalTitleTextAttributes != nil) {
            textAttributes = [NSMutableDictionary dictionaryWithDictionary:self.originalTitleTextAttributes];
        }else{
            textAttributes = [NSMutableDictionary dictionaryWithCapacity:0];
        }
        
        [textAttributes setObject:[UIFont fontWithName:self.originalFont.fontName size:self.originalFont.pointSize] forKey:NSFontAttributeName];
        [self setTitleTextAttributes:textAttributes];
        [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:self.originalFont.fontName size:self.originalFont.pointSize]} forState:UIControlStateNormal];
        [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:self.originalFont.fontName size:self.originalFont.pointSize]} forState:UIControlStateHighlighted];
    }
}


@end
