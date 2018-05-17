//
//  SRFontAdjust.h
//  SRFont
//
//  Created by hlet on 2018/5/17.
//  Copyright © 2018年 hlet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRFontAdjust : NSObject
//字号
@property (nonatomic, assign) float fontMultiple;

/**
 TODO:获取单例
 
 @return 单例
 */
+ (instancetype)single;

/**
 TODO:释放
 */
+ (void)freeData;


@end
