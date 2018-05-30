//
//  MDJSHistory.h
//  MDJavaScriptContext
//
//  Created by xulinfeng on 2018/5/30.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "MDJSImport.h"

@protocol MDJSHistory <MDJSImport>

// 返回历史列表中的网址数
@property (nonatomic, assign, readonly) NSUInteger length;

// 加载 history 列表中的前一个 URL
- (void)back;

// 加载 history 列表中的下一个 URL
- (void)forward;

// 加载 history 列表中的某个具体页面
- (void)go;

@end
