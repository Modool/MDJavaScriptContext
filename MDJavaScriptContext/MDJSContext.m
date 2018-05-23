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
#import "MDJSImport.h"

@implementation MDJSContext

- (instancetype)initWithWebView:(UIWebView *)webView;{
    if (self = [self init]) {
        _webView = webView;
    }
    return self;
}

- (instancetype)init{
    if (self = [super init]) {;
        _mutableExports = NSMutableDictionary.dictionary;
        _mutableImports = NSMutableArray.array;
    }
    return self;
}

#pragma mark - accessor

- (JSContext *)javaScriptContext{
    return _webView.javaScriptContext;
}

- (NSArray<MDJSExport *> *)exports{
    return _mutableExports.copy;
}

- (NSArray<MDJSImport *> *)imports{
    return _mutableImports.copy;
}

#pragma mark - public

- (BOOL)addExport:(MDJSExport *)export_;{
    if ([_mutableExports.allKeys containsObject:export_.name]) return NO;
    if ([_mutableExports.allValues containsObject:export_]) return NO;
    
    _mutableExports[export_.name] = export_;
    return YES;
}

- (BOOL)removeExport:(MDJSExport *)export_;{
    if (![_mutableExports.allKeys containsObject:export_.name]) return NO;
    
    [_mutableExports removeObjectForKey:export_.name];
    [self _removeExport:export_ inContext:self.javaScriptContext];
    return YES;
}

- (BOOL)addImport:(MDJSImport *)import;{
    if ([_mutableImports containsObject:import]) return NO;
    
    [_mutableImports addObject:import];
    return YES;
}

- (BOOL)removeImport:(MDJSImport *)import;{
    if (![_mutableImports containsObject:import]) return NO;
    
    [_mutableImports removeObject:import];
    return YES;
}

#pragma mark - private

- (void)_injectExportsForContext:(JSContext *)context type:(MDJSExportInjectType)type{
    NSDictionary<NSString *, MDJSExport *> *exports = _mutableExports.copy;
    for (NSString *name in exports.allKeys) {
        MDJSExport *export = exports[name];

        if (!(export.injectType & type)) continue;
        
        [export willInjectToContext:context type:type];
        
        context[export.name] = export;
        
        [export didInjectToContext:context type:type];
    }
}

- (void)_removeExport:(MDJSExport *)export inContext:(JSContext *)context{
    context[export.name] = nil;
}

- (void)_injectImportsForContext:(JSContext *)context{
    [_mutableImports setValue:context forKey:@"javaScriptContext"];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView;{
    JSContext *context = webView.javaScriptContext;
    
    [self _injectExportsForContext:context type:MDJSExportInjectTypeBeforeLoading];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView;{
    JSContext *context = webView.javaScriptContext;
    
    [self _injectExportsForContext:context type:MDJSExportInjectTypeAfterLoading];
    [self _injectImportsForContext:context];
}

@end

@implementation UIWebView (JSContext)

- (JSContext *)javaScriptContext{
    return [self valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
}

@end
