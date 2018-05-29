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
