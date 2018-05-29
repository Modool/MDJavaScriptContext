//
//  MDJSStringImport.m
//  MDJavaScriptContext
//
//  Created by xulinfeng on 2018/5/29.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "MDJSStringImport.h"
#import "MDJSImport+Private.h"

@implementation MDJSStringImport

+ (instancetype)importWithJavaScript:(NSString *)javaScript protocol:(Protocol *)protocol type:(MDJSExportInjectType)type;{
    return [[self alloc] initWithJavaScript:javaScript protocol:protocol type:type];
}

- (instancetype)initWithJavaScript:(NSString *)javaScript protocol:(Protocol *)protocol type:(MDJSExportInjectType)type;{
    NSParameterAssert(javaScript.length);
    if (self = [super initWithProtocol:protocol type:type]) {
        _javaScript = javaScript.copy;
    }
    return self;
}

- (instancetype)initWithProtocol:(Protocol *)protocol{
    return [self initWithJavaScript:nil protocol:protocol type:0];
}

+ (instancetype)importWithData:(NSData *)data protocol:(Protocol *)protocol type:(MDJSExportInjectType)type;{
    return [[self alloc] initWithData:data protocol:protocol type:type];
}

- (instancetype)initWithData:(NSData *)data protocol:(Protocol *)protocol type:(MDJSExportInjectType)type;{
    NSString *javaScript = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [self initWithJavaScript:javaScript protocol:protocol type:type];
}

+ (instancetype)importWithFilePath:(NSString *)filePath protocol:(Protocol *)protocol type:(MDJSExportInjectType)type;{
    return [[self alloc] initWithFilePath:filePath protocol:protocol type:type];
}

- (instancetype)initWithFilePath:(NSString *)filePath protocol:(Protocol *)protocol type:(MDJSExportInjectType)type;{
    NSError *error = nil;
    NSString *javaScript = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if (error) return nil;
    
    return [self initWithJavaScript:javaScript protocol:protocol type:type];
}

#pragma mark - protected

- (void)injectExportForContext:(JSContext *)context type:(MDJSExportInjectType)type{
    [context evaluateScript:_javaScript];
}

@end
