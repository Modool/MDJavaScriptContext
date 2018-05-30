//
//  MDJSLocation.h
//  MDJavaScriptContext
//
//  Created by xulinfeng on 2018/5/30.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "MDJSImport.h"

@protocol MDJSLocation <MDJSImport>

// 返回一个URL的主机名和端口
@property (nonatomic, copy, readonly) NSString *host;

// 返回URL的主机名
@property (nonatomic, copy, readonly) NSString *hostname;

// 返回完整的URL
@property (nonatomic, copy, readonly) NSString *href;

// 返回的URL路径名。
@property (nonatomic, copy, readonly) NSString *pathname;

// 返回一个URL服务器使用的端口号
@property (nonatomic, copy, readonly) NSString *port;

// 返回一个URL协议
@property (nonatomic, copy, readonly) NSString *protocol;

// 返回一个URL的查询部分
@property (nonatomic, copy, readonly) NSString *search;

// 载入一个新的文档
- (void)assign:(NSString *)URLString;

// 重新载入当前文档
- (void)reload:(BOOL)forceGet;

// 用新的文档替换当前文档
- (void)replace:(NSString *)URLString;

@end
