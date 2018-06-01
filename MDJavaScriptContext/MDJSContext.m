//
//  MDJSContext.m
//  MDJavaScriptContext
//
//  Created by xulinfeng on 2018/5/21.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "MDJSContext.h"
#import "MDJSContext+Private.h"

#import "MDJSExport+Private.h"
#import "MDJSImport+Private.h"

@implementation MDJSContext

- (instancetype)init{
    return [self initWithWebView:nil];
}

- (instancetype)initWithWebView:(UIWebView *)webView;{
    if (self = [super init]) {
        _webView = webView;
        _mutableExports = NSMutableDictionary.dictionary;
        _mutableImports = NSMutableArray.array;
    }
    return self;
}

#pragma mark - accessor

- (NSArray<MDJSExport<JSExport> *> *)exports{
    return _mutableExports.allValues;
}

- (NSArray<MDJSImport *> *)imports{
    return _mutableImports.copy;
}

- (JSContext *)javaScriptContext{
    if (!_javaScriptContext) {
        _javaScriptContext = _webView.javaScriptContext ?: [JSContext currentContext];
        
    }
    return _javaScriptContext;
}

- (JSValue *)globalObject{
    return self.javaScriptContext.globalObject;
}

#pragma mark - public

- (BOOL)addExport:(MDJSExport<JSExport> *)export;{
    NSParameterAssert([export conformsToProtocol:@protocol(JSExport)]);
    
    if ([_mutableExports.allKeys containsObject:export.name]) return NO;
    if ([_mutableExports.allValues containsObject:export]) return NO;
    
    _mutableExports[export.name] = export;
    
    if (export.injectType & MDJSExportInjectTypeInitializing) {
        [self _injectExport:export context:self.javaScriptContext];
    }
    return YES;
}

- (BOOL)removeExport:(MDJSExport<JSExport> *)export;{
    if (![_mutableExports.allKeys containsObject:export.name]) return NO;
    [_mutableExports removeObjectForKey:export.name];
    
    [self _removeExport:export context:self.javaScriptContext];
    
    return YES;
}

- (BOOL)addImport:(MDJSImport *)import;{
    if ([_mutableImports containsObject:import]) return NO;
    [_mutableImports addObject:import];
    
    if (import.injectType & MDJSExportInjectTypeInitializing) {
        [self _injectImport:import context:self.javaScriptContext];
    }
    return YES;
}

- (BOOL)removeImport:(MDJSImport *)import;{
    if (![_mutableImports containsObject:import]) return NO;
    [_mutableImports removeObject:import];
    
    [self _removeImport:import context:self.javaScriptContext];
    
    return YES;
}

- (JSValue *)evaluateScript:(NSString *)script;{
    return [self.javaScriptContext evaluateScript:script];
}

- (JSValue *)evaluateScript:(NSString *)script withSourceURL:(NSURL *)sourceURL;{
    return [self.javaScriptContext evaluateScript:script withSourceURL:sourceURL];
}

#pragma mark - private

- (void)_injectExportsToContext:(JSContext *)context type:(MDJSExportInjectType)type{
    NSDictionary<NSString *, MDJSExport *> *exports = _mutableExports.copy;
    for (NSString *name in exports.allKeys) {
        MDJSExport *export = exports[name];

        if (!(export.injectType & type)) continue;
        [self _injectExport:export context:context];
    }
}

- (void)_injectExport:(MDJSExport *)export context:(JSContext *)context{
    export.javaScriptContext = context;
    [export willInjectToContext:context javaScriptObject:context.globalObject type:export.injectType];
    [export injectToContext:context javaScriptObject:context.globalObject type:export.injectType];
    [export didInjectToContext:context javaScriptObject:context.globalObject type:export.injectType];
}

- (void)_removeExport:(MDJSExport *)export context:(JSContext *)context{
    [export willRemoveFromContext:context javaScriptObject:context.globalObject];
    [export removeFromContext:context javaScriptObject:context.globalObject];
    [export didRemoveFromContext:context javaScriptObject:context.globalObject];
    
    export.javaScriptContext = nil;
}

- (void)_injectImportsToContext:(JSContext *)context type:(MDJSExportInjectType)type{
    for (MDJSImport *import in _mutableImports.copy) {
        if (!(import.injectType & type)) continue;
        [self _injectImport:import context:context];
    }
}

- (void)_injectImport:(MDJSImport *)import context:(JSContext *)context{
    import.javaScriptContext = context;
    [import willInjectToContext:context type:import.injectType];
    [import injectExportForContext:context type:import.injectType];
    [import didInjectToContext:context type:import.injectType];
}

- (void)_removeImport:(MDJSImport *)import context:(JSContext *)context{
    [import willRemoveFromContext:context];
    [import removeFromContext:context];
    [import didRemoveFromContext:context];
    
    import.javaScriptContext = nil;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView;{
    JSContext *context = webView.javaScriptContext;
    self.javaScriptContext = context;
    
    [self _injectExportsToContext:context type:MDJSExportInjectTypeStartLoading];
    [self _injectImportsToContext:context type:MDJSExportInjectTypeStartLoading];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView;{
    JSContext *context = webView.javaScriptContext;
    self.javaScriptContext = context;
    
    [self _injectExportsToContext:context type:MDJSExportInjectTypeAfterLoading];
    [self _injectImportsToContext:context type:MDJSExportInjectTypeAfterLoading];
}

@end

@implementation UIWebView (JSContext)

- (JSContext *)javaScriptContext{
    return [self valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
}

@end
