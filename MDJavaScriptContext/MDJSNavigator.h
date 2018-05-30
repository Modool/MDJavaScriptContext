//
//  MDJSNavigator.h
//  MDJavaScriptContext
//
//  Created by xulinfeng on 2018/5/30.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "MDJSImport.h"

@protocol MDJSNavigator <MDJSImport>

// 返回浏览器的代码名
@property (nonatomic, copy, readonly) NSString *appCodeName;

// 返回浏览器的名称
@property (nonatomic, copy, readonly) NSString *appName;

// 返回浏览器的平台和版本信息
@property (nonatomic, copy, readonly) NSString *appVersion;

// 返回运行浏览器的操作系统平台
@property (nonatomic, copy, readonly) NSString *platform;

// 返回由客户机发送服务器的user-agent 头部的值
@property (nonatomic, copy, readonly) NSString *userAgent;

// 返回指明浏览器中是否启用 cookie 的布尔值
@property (nonatomic, assign, readonly) BOOL cookieEnabled;

// 指定是否在浏览器中启用Java
- (BOOL)javaEnabled;

// 规定浏览器是否启用数据污点(data tainting)
- (BOOL)taintEnabled;

@end
