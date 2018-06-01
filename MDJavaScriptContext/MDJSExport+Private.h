//
//  MDJSExport+Private.h
//  MDJavaScriptContext
//
//  Created by xulinfeng on 2018/5/22.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "MDJSExport.h"

@interface MDJSExport ()

@property (nonatomic, weak) JSContext *javaScriptContext;

@property (nonatomic, strong, readonly) JSValue *javaScriptValue;

@property (nonatomic, strong) NSMutableArray<MDJSExport<JSExport> *> *mutableSubExports;

- (void)willInjectToContext:(JSContext *)context javaScriptObject:(JSValue *)javaScriptObject type:(MDJSExportInjectType)type;
- (void)injectToContext:(JSContext *)context javaScriptObject:(JSValue *)javaScriptObject type:(MDJSExportInjectType)type;
- (void)didInjectToContext:(JSContext *)context javaScriptObject:(JSValue *)javaScriptObject type:(MDJSExportInjectType)type;

- (void)willRemoveFromContext:(JSContext *)context javaScriptObject:(JSValue *)javaScriptObject;
- (void)removeFromContext:(JSContext *)context javaScriptObject:(JSValue *)javaScriptObject;
- (void)didRemoveFromContext:(JSContext *)context javaScriptObject:(JSValue *)javaScriptObject;

@end
