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
    }
    return self;
}

- (instancetype)init{
    return [self initWithName:NSStringFromClass(self.class) type:MDJSExportInjectTypeAfterLoading];
}

- (NSString *)description{
    return [NSString stringWithFormat:@"<%@, %llu> name: %@, injectType: %lulu", self.class, (UInt64)self, _name, (unsigned long)_injectType];
}

- (void)willInjectToContext:(JSContext *)context type:(MDJSExportInjectType)type;{
    self.javaScriptContext = context;
}

- (void)didInjectToContext:(JSContext *)context type:(MDJSExportInjectType)type;{
    self.javaScriptContext = context;
}

- (void)willRemoveFromContext:(JSContext *)context type:(MDJSExportInjectType)type;{
    self.javaScriptContext = nil;
}

- (void)didRemoveFromContext:(JSContext *)context type:(MDJSExportInjectType)type;{
    self.javaScriptContext = nil;
}

@end
