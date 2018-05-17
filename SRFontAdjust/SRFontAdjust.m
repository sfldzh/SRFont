//
//  SRFontAdjust.m
//  SRFont
//
//  Created by hlet on 2018/5/17.
//  Copyright © 2018年 hlet. All rights reserved.
//

#import "SRFontAdjust.h"

static SRFontAdjust *_fontAdjust = nil;
@implementation SRFontAdjust

/**
 TODO:获取单例
 
 @return 单例
 */
+ (instancetype)single{
    @synchronized(self) {
        if (!_fontAdjust) {
            _fontAdjust = [[self alloc] init];
        }
    }
    return _fontAdjust;
}

/**
 TODO:释放
 */
+ (void)freeData{
    if (_fontAdjust) {
        _fontAdjust = nil;
    }
}


@end
