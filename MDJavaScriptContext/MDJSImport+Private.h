//
//  MDJSImport+Private.h
//  MDJavaScriptContext
//
//  Created by xulinfeng on 2018/5/22.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "MDJSImport.h"

@interface MDJSImport ()

@property (nonatomic, weak) JSContext *javaScriptContext;

// Default is JSContext.globalObject
@property (nonatomic, strong, readonly) JSValue *javaScriptObject;

- (void)willInjectToContext:(JSContext *)context type:(MDJSExportInjectType)type;
- (void)injectExportForContext:(JSContext *)context type:(MDJSExportInjectType)type;
- (void)didInjectToContext:(JSContext *)context type:(MDJSExportInjectType)type;

- (void)willRemoveFromContext:(JSContext *)context;
- (void)removeFromContext:(JSContext *)context;
- (void)didRemoveFromContext:(JSContext *)context;

@end

@interface MDJSStringImport : MDJSImport

@property (nonatomic, copy, readonly) NSString *javaScript;

- (instancetype)initWithJavaScript:(NSString *)javaScript protocol:(Protocol *)protocol type:(MDJSExportInjectType)type NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithData:(NSData *)data protocol:(Protocol *)protocol type:(MDJSExportInjectType)type;
- (instancetype)initWithFilePath:(NSString *)filePath protocol:(Protocol *)protocol type:(MDJSExportInjectType)type;

@end

@interface MDJSObjectImport : MDJSImport

@property (nonatomic, copy, readonly) JSValue *referencedObject;
@property (nonatomic, copy, readonly) NSString *keyPath;

- (instancetype)initWithKeyPath:(NSString *)keyPath protocol:(Protocol *)protocol type:(MDJSExportInjectType)type NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithObject:(JSValue *)object protocol:(Protocol *)protocol NS_DESIGNATED_INITIALIZER;

@end
