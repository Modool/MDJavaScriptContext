//
//  MDJSImport.m
//  MDJavaScriptContext
//
//  Created by xulinfeng on 2018/5/21.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <objc/runtime.h>
#import <UIKit/UIKit.h>

#import "MDJSImport.h"
#import "MDJSImport+Private.h"

typedef struct objc_method_description objc_method_description_t;

NSString * const MDJSImportPropertyNameImportPrefix = @"__MDJS_IMPORT_AS__";

NSArray<NSString *> *MDJSImportBoxValues(NSInvocation *invocation) {
    NSMutableArray *values = [NSMutableArray array];
    NSUInteger count = invocation.methodSignature.numberOfArguments;
    for (int index = 2; index < count; index++) {
        id obj = nil;
        const char *type = [invocation.methodSignature getArgumentTypeAtIndex:index];
        if (*type == '@') {
            [invocation getArgument:&obj atIndex:index];
        } else if (*type == '{') {
            void *value = NULL;
            [invocation getArgument:&value atIndex:index];
            obj = [NSValue value:value withObjCType:type];
        } else if (*type == *@encode(double) || *type == *@encode(float)) {
            double value;
            [invocation getArgument:&value atIndex:index];
            obj = [NSNumber numberWithDouble:value];
        } else if (*type == *@encode(int) ||
                   *type == *@encode(char) ||
                   *type == *@encode(short) ||
                   *type == *@encode(long) ||
                   *type == *@encode(long long) ||
                   *type == *@encode(bool)) {
            long long value = 0;
            [invocation getArgument:&value atIndex:index];
            obj = [NSNumber numberWithLongLong:value];
        } else if (*type == *@encode(unsigned int) ||
                   *type == *@encode(unsigned char) ||
                   *type == *@encode(unsigned short) ||
                   *type == *@encode(unsigned long) ||
                   *type == *@encode(unsigned long long)) {
            unsigned long long value = 0;
            [invocation getArgument:&value atIndex:index];
            obj = [NSNumber numberWithLongLong:value];
        }
        [values addObject:obj];
    }
    return values;
}

@implementation MDJSImport

+ (instancetype)importWithProtocol:(Protocol *)protocol type:(MDJSExportInjectType)type;{
    return [[self alloc] initWithProtocol:protocol type:type];
}

- (instancetype)initWithProtocol:(Protocol *)protocol type:(MDJSExportInjectType)type;{
    NSParameterAssert(protocol);
    NSParameterAssert(protocol_conformsToProtocol(protocol, @protocol(MDJSImport)));
    
    if (self = [super init]) {
        _protocol = protocol;
        _injectType = type;
    }
    return self;
}

- (instancetype)init{
    return [self initWithProtocol:@protocol(MDJSImport) type:0];
}

#pragma mark - accessor

- (JSValue *)javaScriptObject{
    return self.javaScriptContext.globalObject;
}

#pragma mark - private

- (NSString *)_functionForSelector:(SEL)selector{
    NSString *functionName = [self _functionNameWithSelector:selector required:NO];

    if (!functionName.length) {
        functionName = [self _functionNameWithSelector:selector required:YES];
    }
    if (!functionName.length) {
        functionName = [self _defaultFunctionNameFromSelectorName:NSStringFromSelector(selector)];
    }
    return functionName;
}

- (NSString *)_functionNameWithSelector:(SEL)selector required:(BOOL)required{
    NSString *selectorName = NSStringFromSelector(selector);
    BOOL isGetter = ![selectorName containsString:@":"];
    
    NSString *functionName = nil;
    unsigned int count = 0;
    objc_method_description_t *descriptions = protocol_copyMethodDescriptionList(_protocol, required, YES, &count);
    
    for (int index = 0; index < count; index++) {
        objc_method_description_t description = descriptions[index];
        NSString *methodSelectorName = NSStringFromSelector(description.name);
        
        if (![methodSelectorName containsString:selectorName]) continue;
        
        NSRange range = [methodSelectorName rangeOfString:MDJSImportPropertyNameImportPrefix];
        if (range.location == NSNotFound) continue;
        
        NSUInteger location = range.location + range.length;
        functionName = [methodSelectorName substringWithRange:NSMakeRange(location, methodSelectorName.length - location - !isGetter)];
        break;
    }
    return functionName;
}

- (NSString *)_defaultFunctionNameFromSelectorName:(NSString *)selectorName{
    BOOL isGetter = ![selectorName containsString:@":"];
    if (isGetter) return selectorName;
    
    NSMutableString *result = [NSMutableString string];
    NSArray<NSString *> *labels = [selectorName componentsSeparatedByString:@":"];
    for (int index = 0; index < labels.count; index++) {
        NSString *label = labels[index];
        if (!label.length) continue;
        if (index) {
            NSString *firstCharacter = [[label substringToIndex:1] uppercaseString];
            label = [label stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstCharacter];
        }
        [result appendString:label];
    }
    return result.copy;
}

- (JSValue *)_forwardFunction:(NSString *)function invocation:(NSInvocation *)invocation{
    NSArray *arguments = MDJSImportBoxValues(invocation);
    JSValue *javaScriptObject = self.javaScriptObject;

    if ([javaScriptObject isUndefined] || [javaScriptObject isNull]) return javaScriptObject;
    
    return [javaScriptObject invokeMethod:function withArguments:arguments];
}

- (void)_invokeInvocation:(NSInvocation *)invocation value:(JSValue *)value{
    const char *type = invocation.methodSignature.methodReturnType;
    NSUInteger length = invocation.methodSignature.methodReturnLength;
    
    if (*type == '@') {
        if (![value isUndefined] && ![value isNull] && !JSObjectIsFunction(value.context.JSGlobalContextRef, (JSObjectRef)value.JSValueRef)) {
            if ([value isString]) {
                NSString *string = [value toString];
                [invocation setReturnValue:&string];
            } else if ([value isObject]) {
                id object = [value toObject];
                [invocation setReturnValue:&object];
            }
        }
    } else if (*type == '{'){
        id obj = [value toObject];
        if ([obj isKindOfClass:NSValue.class]) {
            void *structValue = NULL;
            if (@available(iOS 11, *)) {
                [obj getValue:&structValue size:length];
            } else {
                [obj getValue:&structValue];
            }
            [invocation setReturnValue:&structValue];
        } else {
            [invocation setReturnValue:&obj];
        }
    } else if (*type == *@encode(int) ||
               *type == *@encode(char) ||
               *type == *@encode(short) ||
               *type == *@encode(long) ||
               *type == *@encode(long long) ||
               *type == *@encode(bool)) {
        long long longLongValue = ([value isUndefined] || [value isNull]) ? 0 : [[value toNumber] longLongValue];
        [invocation setReturnValue:&longLongValue];
    } else if (*type == *@encode(unsigned int) ||
               *type == *@encode(unsigned char) ||
               *type == *@encode(unsigned short) ||
               *type == *@encode(unsigned long) ||
               *type == *@encode(unsigned long long)) {
        
        unsigned long long unsignedLongLongValue = ([value isUndefined] || [value isNull]) ? 0 : [[value toNumber] unsignedLongLongValue];
        [invocation setReturnValue:&unsignedLongLongValue];
    } else if (*type == *@encode(double) || *type == *@encode(float)) {
        
        double doubleValue = ([value isUndefined] || [value isNull]) ? 0 : [[value toNumber] doubleValue];
        [invocation setReturnValue:&doubleValue];
    } else if (*type != 'v') {
        [invocation setReturnValue:&value];
    }
    
    invocation.target = nil;
    [invocation invoke];
}

- (BOOL)_methodDescriptionForSelector:(SEL)selector description:(objc_method_description_t *)description{
    objc_method_description_t desc = protocol_getMethodDescription(_protocol, selector, NO, YES);
    if (desc.name && desc.types) {
        *description = desc;
        return YES;
    }
    desc = protocol_getMethodDescription(_protocol, selector, YES, YES);
    if (desc.name && desc.types) {
        *description = desc;
        return YES;
    }
    
    return NO;
}

#pragma mark - protected

- (void)forwardInvocation:(NSInvocation *)anInvocation{
    NSString *functionName = [self _functionForSelector:anInvocation.selector];
    if (functionName.length) {
        JSValue *value = [self _forwardFunction:functionName invocation:anInvocation];
        [self _invokeInvocation:anInvocation value:value];
    } else {
        [super forwardInvocation:anInvocation];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    objc_method_description_t description;
    
    if ([self _methodDescriptionForSelector:aSelector description:&description]) {
        return [NSMethodSignature signatureWithObjCTypes:description.types];
    }
    return [super methodSignatureForSelector:aSelector];
}

- (void)willInjectToContext:(JSContext *)context type:(MDJSExportInjectType)type;{
}

- (void)injectExportForContext:(JSContext *)context type:(MDJSExportInjectType)type{
}

- (void)didInjectToContext:(JSContext *)context type:(MDJSExportInjectType)type;{
}

- (void)willRemoveFromContext:(JSContext *)context;{
}

- (void)removeFromContext:(JSContext *)context{
}

- (void)didRemoveFromContext:(JSContext *)context;{
}

@end
