//
//  MDJSStringImport.h
//  MDJavaScriptContext
//
//  Created by xulinfeng on 2018/5/29.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <MDJavaScriptContext/MDJavaScriptContext.h>

@interface MDJSStringImport : MDJSImport

@property (nonatomic, copy, readonly) NSString *javaScript;

+ (instancetype)importWithProtocol:(Protocol *)protocol type:(MDJSExportInjectType)type NS_UNAVAILABLE;
- (instancetype)initWithProtocol:(Protocol *)protocol type:(MDJSExportInjectType)type NS_UNAVAILABLE;

+ (instancetype)importWithJavaScript:(NSString *)javaScript protocol:(Protocol *)protocol type:(MDJSExportInjectType)type;
- (instancetype)initWithJavaScript:(NSString *)javaScript protocol:(Protocol *)protocol type:(MDJSExportInjectType)type NS_DESIGNATED_INITIALIZER;

+ (instancetype)importWithData:(NSData *)data protocol:(Protocol *)protocol type:(MDJSExportInjectType)type;
- (instancetype)initWithData:(NSData *)data protocol:(Protocol *)protocol type:(MDJSExportInjectType)type;

+ (instancetype)importWithFilePath:(NSString *)filePath protocol:(Protocol *)protocol type:(MDJSExportInjectType)type;
- (instancetype)initWithFilePath:(NSString *)filePath protocol:(Protocol *)protocol type:(MDJSExportInjectType)type;

@end
