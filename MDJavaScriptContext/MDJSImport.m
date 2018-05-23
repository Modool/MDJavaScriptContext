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
            long long value;
            [invocation getArgument:&value atIndex:index];
            obj = [NSNumber numberWithLongLong:value];
        } else if (*type == *@encode(unsigned int) ||
                   *type == *@encode(unsigned char) ||
                   *type == *@encode(unsigned short) ||
                   *type == *@encode(unsigned long) ||
                   *type == *@encode(unsigned long long)) {
            unsigned long long value;
            [invocation getArgument:&value atIndex:index];
            obj = [NSNumber numberWithLongLong:value];
        }
        [values addObject:obj];
    }
    return values;
}

void *MDJSImportBoxReturnValue(const char *type, NSUInteger length, JSValue *value){
    void *result = *type == 'v' ? NULL : (__bridge void *)value;
    
    if (*type == '@') {
        if ([value isUndefined] || [value isNull]) {
            result = NULL;
        } else if (!JSObjectIsFunction(value.context.JSGlobalContextRef, (JSObjectRef)value.JSValueRef)) {
            if ([value isString]) result = (__bridge void *)[value toString];
            else if ([value isObject]) result = (__bridge void *)[value toObject];
        }
    } else if (*type == '{' ||
               *type == *@encode(double) || *type == *@encode(float) ||
               *type == *@encode(int) || *type == *@encode(unsigned int) ||
               *type == *@encode(char) || *type == *@encode(unsigned char) ||
               *type == *@encode(short) || *type == *@encode(unsigned short) ||
               *type == *@encode(long) || *type == *@encode(unsigned long) ||
               *type == *@encode(long long) || *type == *@encode(unsigned long long) ||
               *type == *@encode(bool)) {
        id obj = [value toObject];
        if ([obj isKindOfClass:NSValue.class]) {
            if (@available(iOS 11, *)) {
                [obj getValue:&result size:length];
            } else {
                [obj getValue:&result];
            }
        }
    }
    return result;
}

@implementation MDJSImport

+ (instancetype)importWithProtocol:(Protocol *)protocol;{
    return [[self alloc] initWithProtocol:protocol];
}

- (instancetype)initWithProtocol:(Protocol *)protocol;{
    NSParameterAssert(protocol);
    if (self = [super init]) {
        _protocol = protocol;
    }
    return self;
}

- (instancetype)init{
    return [self initWithProtocol:nil];
}

#pragma mark - private

- (NSString *)_functionForSelector:(SEL)selector{
    NSString *selectorName = NSStringFromSelector(selector);
    BOOL isGetter = ![selectorName containsString:@":"];
    
    NSString *functionName = nil;
    unsigned int count = 0;
    objc_method_description_t *descriptions = protocol_copyMethodDescriptionList(_protocol, NO, YES, &count);
    
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
    if (!functionName.length) {
        if (isGetter) functionName = selectorName;
        else functionName = [[selectorName substringToIndex:selectorName.length - 2] stringByReplacingOccurrencesOfString:@":" withString:@"_"];
    }
    return functionName;
}

- (JSValue *)_forwardFunction:(NSString *)function invocation:(NSInvocation *)invocation{
    NSArray *arguments = MDJSImportBoxValues(invocation);
    JSValue *globalObject = self.javaScriptContext.globalObject;
//    NSString *script = [function stringByAppendingFormat:@"(%@)", [arguments componentsJoinedByString:@","]];
    
    return [globalObject invokeMethod:function withArguments:arguments];
}

- (void)_invokeInvocation:(NSInvocation *)invocation returnValue:(JSValue *)returnValue{
    const char *type = invocation.methodSignature.methodReturnType;
    NSUInteger length = invocation.methodSignature.methodReturnLength;
    void *value = MDJSImportBoxReturnValue(type, length, returnValue);
    if (value) [invocation setReturnValue:&value];
    
    invocation.target = nil;
    [invocation invoke];
}

#pragma mark - protected

- (void)forwardInvocation:(NSInvocation *)anInvocation{
    NSString *functionName = [self _functionForSelector:anInvocation.selector];
    if (functionName.length) {
        JSValue *value = [self _forwardFunction:functionName invocation:anInvocation];
        [self _invokeInvocation:anInvocation returnValue:value];
    } else {
        [super forwardInvocation:anInvocation];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    struct objc_method_description description = protocol_getMethodDescription(_protocol, aSelector, NO, YES);
    
    if (description.name && description.types) {
        return [NSMethodSignature signatureWithObjCTypes:description.types];
    }
    return [super methodSignatureForSelector:aSelector];
}

@end
