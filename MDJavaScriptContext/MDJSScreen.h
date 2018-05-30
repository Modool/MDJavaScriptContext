//
//  MDJSScreen.h
//  MDJavaScriptContext
//
//  Created by xulinfeng on 2018/5/30.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "MDJSImport.h"

@protocol MDJSScreen <MDJSImport>

// 返回屏幕的高度（不包括Windows任务栏）
@property (nonatomic, assign, readonly) CGFloat availHeight;

// 返回屏幕的宽度（不包括Windows任务栏）
@property (nonatomic, assign, readonly) CGFloat availWidth;

// 返回目标设备或缓冲器上的调色板的比特深度
@property (nonatomic, assign, readonly) CGFloat colorDepth;

// 返回屏幕的总高度
@property (nonatomic, assign, readonly) CGFloat height;

// 返回屏幕的颜色分辨率（每象素的位数）
@property (nonatomic, assign, readonly) CGFloat pixelDepth;

// 返回屏幕的总宽度
@property (nonatomic, assign, readonly) CGFloat width;

@end
