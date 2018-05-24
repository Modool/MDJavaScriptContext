//
//  MDJSContext+Private.h
//  MDJavaScriptContext
//
//  Created by xulinfeng on 2018/5/22.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDJSContext.h"

#import "MDJSExport.h"
#import "MDJSImport.h"

@interface MDJSContext ()<UIWebViewDelegate>

@property (nonatomic, strong) JSContext *javaScriptContext;

@property (nonatomic, strong) NSMutableDictionary<NSString *, MDJSExport<JSExport> *> *mutableExports;
@property (nonatomic, strong) NSMutableArray<MDJSImport *> *mutableImports;

- (void)_injectExportsForContext:(JSContext *)context type:(MDJSExportInjectType)type;
- (void)_removeExport:(MDJSExport *)export inContext:(JSContext *)context;

- (void)_injectImportsForContext:(JSContext *)context;

@end

@interface UIWebView (JSContext)

@property (nonatomic, strong, readonly) JSContext *javaScriptContext;

@end
