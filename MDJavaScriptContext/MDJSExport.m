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

#pragma mark - accessor

- (NSArray<MDJSExport<JSExport> *> *)subExports{
    return _mutableSubExports.copy;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"<%@, %llu> name: %@, injectType: %lu", self.class, (UInt64)self, _name, (unsigned long)_injectType];
}

#pragma mark - private

- (void)_willInjectSubExportsToContext:(JSContext *)context type:(MDJSExportInjectType)type{
    for (MDJSExport *export in _mutableSubExports.copy) {
        if (!(type & export.injectType)) continue;
        
        [export willInjectToContext:context type:type];
    }
}

- (void)_injectSubExportsForType:(MDJSExportInjectType)type{
    for (MDJSExport *export in _mutableSubExports.copy) {
        if (!(type & export.injectType)) continue;
        
        _javaScriptValue[export.name] = export;
    }
}

- (void)_didInjectSubExportsToContext:(JSContext *)context type:(MDJSExportInjectType)type{
    for (MDJSExport *export in _mutableSubExports.copy) {
        if (!(type & export.injectType)) continue;
        
        [export didInjectToContext:context type:type];
    }
}

- (void)_willRemoveSubExportsFromContext:(JSContext *)context{
    for (MDJSExport *export in _mutableSubExports.copy) {
        [export willRemoveFromContext:context];
    }
}

- (void)_didRemoveSubExportsFromContext:(JSContext *)context{
    for (MDJSExport *export in _mutableSubExports.copy) {
        [export didRemoveFromContext:context];
    }
}

- (void)_removeSubExport:(MDJSExport *)export{
    _javaScriptValue[export.name] = nil;
}

#pragma mark - protected

- (void)willInjectToContext:(JSContext *)context type:(MDJSExportInjectType)type;{
    [self _willInjectSubExportsToContext:context type:type];
}

- (void)injectExportForContext:(JSContext *)context type:(MDJSExportInjectType)type{
    _javaScriptValue = [JSValue valueWithObject:self inContext:context];
    
    context[self.name] = _javaScriptValue;
    
    [self _injectSubExportsForType:type];
}

- (void)didInjectToContext:(JSContext *)context type:(MDJSExportInjectType)type;{
}

- (void)willRemoveFromContext:(JSContext *)context;{
    [self _willRemoveSubExportsFromContext:context];
}

- (void)removeFromContext:(JSContext *)context{
    _javaScriptValue = nil;
    context[self.name] = nil;
}

- (void)didRemoveFromContext:(JSContext *)context;{
    [self _didRemoveSubExportsFromContext:context];
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
    
    [self _removeSubExport:subExport];
    return YES;
}

@end
