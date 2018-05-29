//
//  MDJSObjectImport.m
//  MDJavaScriptContext
//
//  Created by xulinfeng on 2018/5/29.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "MDJSObjectImport.h"
#import "MDJSImport+Private.h"

@implementation MDJSObjectImport

+ (instancetype)importWithKeyPath:(NSString *)keyPath protocol:(Protocol *)protocol type:(MDJSExportInjectType)type;{
    return  [[self alloc] initWithKeyPath:keyPath protocol:protocol type:type];
}

- (instancetype)initWithKeyPath:(NSString *)keyPath protocol:(Protocol *)protocol type:(MDJSExportInjectType)type{
    if (self = [super initWithProtocol:protocol type:type]) {
        _keyPath = keyPath.copy;
    }
    return self;
}

#pragma mark - accessor

- (JSValue *)javaScriptObject{
    JSValue *value = [[self javaScriptContext] globalObject];
    NSArray<NSString *> *keys = [_keyPath componentsSeparatedByString:@"."];
    for (NSString *key in keys) {
        value = [value objectForKeyedSubscript:key];
    }
    return value ?: [super javaScriptObject];
}

@end
