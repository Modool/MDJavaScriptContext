//
//  MDJSExport+Private.h
//  MDJavaScriptContext
//
//  Created by xulinfeng on 2018/5/22.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "MDJSExport.h"

@interface MDJSExport ()

@property (nonatomic, weak, readonly) JSValue *javaScriptValue;

@property (nonatomic, weak) JSContext *javaScriptContext;

@property (nonatomic, strong) NSMutableArray<MDJSExport<JSExport> *> *mutableSubExports;

- (void)willInjectToContext:(JSContext *)context type:(MDJSExportInjectType)type;
- (void)injectExportForContext:(JSContext *)context type:(MDJSExportInjectType)type;
- (void)didInjectToContext:(JSContext *)context type:(MDJSExportInjectType)type;

- (void)willRemoveFromContext:(JSContext *)context;
- (void)removeFromContext:(JSContext *)context;
- (void)didRemoveFromContext:(JSContext *)context;

@end
