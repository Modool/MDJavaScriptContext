//
//  MDJSExport.m
//  MDJavaScriptContext
//
//  Created by xulinfeng on 2018/5/21.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "MDJSExport.h"
#import "MDJSExport+Private.h"

#import "MDJSImport+Private.h"

@implementation MDJSExport

+ (instancetype)exportWithName:(NSString *)name type:(MDJSExportInjectType)type;{
    return [[self alloc] initWithName:name type:type];
}

- (instancetype)initWithName:(NSString *)name type:(MDJSExportInjectType)type;{
    if (self = [super init]) {
        _name = name.copy;
        _injectType = type;
        _mutableSubExports = [NSMutableArray array];
    }
    return self;
}

- (instancetype)init{
    return [self initWithName:NSStringFromClass(self.class) type:MDJSExportInjectTypeAfterLoading];
}

- (void)dealloc{
    [_mutableSubExports removeAllObjects];
    
    _name = nil;
    _mutableSubExports = nil;
    _javaScriptValue = nil;
    _javaScriptContext = nil;
}

#pragma mark - accessor

- (NSArray<MDJSExport<JSExport> *> *)subExports{
    return _mutableSubExports.copy;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"<%@, %llu> name: %@, injectType: %lu", self.class, (UInt64)self, _name, (unsigned long)_injectType];
}

#pragma mark - private

- (void)_willInjectSubExportsToContext:(JSContext *)context javaScriptObject:(JSValue *)javaScriptObject type:(MDJSExportInjectType)type{
    for (MDJSExport *export in _mutableSubExports.copy) {
        if (!(type & export.injectType)) continue;
        
        [export willInjectToContext:context javaScriptObject:javaScriptObject type:type];
    }
}

- (void)_injectSubExportsToContext:(JSContext *)context javaScriptObject:(JSValue *)javaScriptObject type:(MDJSExportInjectType)type{
    for (MDJSExport *export in _mutableSubExports.copy) {
        if (!(type & export.injectType)) continue;
        
        [export injectToContext:context javaScriptObject:javaScriptObject type:type];
    }
}

- (void)_didInjectSubExportsToContext:(JSContext *)context javaScriptObject:(JSValue *)javaScriptObject type:(MDJSExportInjectType)type{
    for (MDJSExport *export in _mutableSubExports.copy) {
        if (!(type & export.injectType)) continue;
        
        [export didInjectToContext:context javaScriptObject:javaScriptObject type:type];
    }
}

- (void)_willRemoveSubExportsFromContext:(JSContext *)context javaScriptObject:(JSValue *)javaScriptObject{
    for (MDJSExport *export in _mutableSubExports.copy) {
        [export willRemoveFromContext:context javaScriptObject:javaScriptObject];
    }
}

- (void)_didRemoveSubExportsFromContext:(JSContext *)context javaScriptObject:(JSValue *)javaScriptObject{
    for (MDJSExport *export in _mutableSubExports.copy) {
        [export didRemoveFromContext:context javaScriptObject:javaScriptObject];
    }
}

- (void)_removeSubExport:(MDJSExport *)export javaScripObject:(JSValue *)javaScriptObject{
    _javaScriptValue[export.name] = nil;
}

#pragma mark - protected

- (void)willInjectToContext:(JSContext *)context javaScriptObject:(JSValue *)javaScriptObject type:(MDJSExportInjectType)type;{
    _javaScriptValue = [JSValue valueWithObject:self inContext:context];
    
    [self _willInjectSubExportsToContext:context javaScriptObject:_javaScriptValue type:type];
}

- (void)injectToContext:(JSContext *)context javaScriptObject:(JSValue *)javaScriptObject type:(MDJSExportInjectType)type{
    javaScriptObject[self.name] = _javaScriptValue;
    
    [self _injectSubExportsToContext:context javaScriptObject:_javaScriptValue type:type];
}

- (void)didInjectToContext:(JSContext *)context javaScriptObject:(JSValue *)javaScriptObject type:(MDJSExportInjectType)type;{
}

- (void)willRemoveFromContext:(JSContext *)context javaScriptObject:(JSValue *)javaScriptObject;{
    [self _willRemoveSubExportsFromContext:context javaScriptObject:_javaScriptValue];
}

- (void)removeFromContext:(JSContext *)context javaScriptObject:(JSValue *)javaScriptObject{
    javaScriptObject[self.name] = nil;
}

- (void)didRemoveFromContext:(JSContext *)context javaScriptObject:(JSValue *)javaScriptObject;{
    [self _didRemoveSubExportsFromContext:context javaScriptObject:_javaScriptValue];
    _javaScriptValue = nil;
}

#pragma mark - public

- (BOOL)addSubExport:(MDJSExport<JSExport> *)subExport;{
    if ([_mutableSubExports containsObject:subExport]) return NO;
    [_mutableSubExports addObject:subExport];
    
    return YES;
}

- (BOOL)removeSubExport:(MDJSExport<JSExport> *)subExport;{
    if (![_mutableSubExports containsObject:subExport]) return NO;
    [_mutableSubExports removeObject:subExport];
    
    [self _removeSubExport:subExport javaScripObject:_javaScriptValue];
    return YES;
}

@end
