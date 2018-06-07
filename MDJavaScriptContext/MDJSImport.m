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
#import "MDJSContext+Private.h"

typedef struct objc_method_description objc_method_description_t;

NSString * const MDJSImportPropertyNameImportPrefix = @"__MDJS_IMPORT_AS__";

NSArray<JSValue *> *MDJSImportBoxValues(JSContext *context, NSInvocation *invocation) {
    NSMutableArray *values = [NSMutableArray array];
    NSUInteger count = invocation.methodSignature.numberOfArguments;
    for (int index = 2; index < count; index++) {
        JSValue *javaScriptValue = nil;
        const char *type = [invocation.methodSignature getArgumentTypeAtIndex:index];
        if (*type == '@') {
            id object = nil;
            [invocation getArgument:&object atIndex:index];
            if ([object isKindOfClass:JSValue.class]) javaScriptValue = object;
            else javaScriptValue = [JSValue valueWithObject:object inContext:context];
        } else if (*type == '{') {
            void *value = NULL;
            [invocation getArgument:&value atIndex:index];
            javaScriptValue = [JSValue valueWithObject:[NSValue value:value withObjCType:type] inContext:context];
        } else if (*type == *@encode(double) || *type == *@encode(float)) {
            double value = 0;
            [invocation getArgument:&value atIndex:index];
            javaScriptValue = [JSValue valueWithDouble:value inContext:context];
        } else if (*type == *@encode(int) ||
                   *type == *@encode(char) ||
                   *type == *@encode(short) ||
                   *type == *@encode(bool)) {
            int value = 0;
            [invocation getArgument:&value atIndex:index];
            javaScriptValue = [JSValue valueWithInt32:value inContext:context];
        } else if (*type == *@encode(long) ||
                   *type == *@encode(long long)) {
            long long value = 0;
            [invocation getArgument:&value atIndex:index];
            javaScriptValue = [JSValue valueWithDouble:value inContext:context];
        } else if (*type == *@encode(unsigned int) ||
                   *type == *@encode(unsigned char) ||
                   *type == *@encode(unsigned short) ) {
            unsigned int value = 0;
            [invocation getArgument:&value atIndex:index];
            javaScriptValue = [JSValue valueWithUInt32:value inContext:context];
        } else if (*type == *@encode(unsigned long) ||
                   *type == *@encode(unsigned long long)) {
            unsigned long long value = 0;
            [invocation getArgument:&value atIndex:index];
            javaScriptValue = [JSValue valueWithDouble:value inContext:context];
        }
        javaScriptValue = javaScriptValue ?: [JSValue valueWithNullInContext:context];
        [values addObject:javaScriptValue];
    }
    return values.count ? values : nil;
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

- (void)dealloc{
    _javaScriptContext = nil;
}

#pragma mark - accessor

- (JSValue *)javaScriptObject{
    return self.javaScriptContext.globalObject;
}

#pragma mark - private

- (NSString *)_functionForSelector:(SEL)selector isProperty:(BOOL *)isProperty isGetter:(BOOL *)isGetter{
    NSString *functionName = [self _propertyNameWithSelector:selector isGetter:isGetter];
    if (functionName.length) {
        *isProperty = YES;
        return functionName;
    }
    
    functionName = [self _functionNameWithSelector:selector required:NO];
    
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

- (const char *)_setterName:(const char *)name{
    size_t nameLength = strlen(name);
    char* setterName = (char*)malloc(nameLength + 5); // "set" Name ":\0"
    setterName[0] = 's';
    setterName[1] = 'e';
    setterName[2] = 't';
    setterName[3] = toupper(*name);
    memcpy(setterName + 4, name + 1, nameLength - 1);
    setterName[nameLength + 3] = ':';
    setterName[nameLength + 4] = '\0';
    
    return setterName;
}

- (NSString *)_propertyNameWithSelector:(SEL)selector isGetter:(BOOL *)isGetter{
    const char *selectorName = sel_getName(selector);
    
    unsigned int count = 0;
    objc_property_t *properties = protocol_copyPropertyList(_protocol, &count);
    for (int index = 0; index < count; index++) {
        objc_property_t property = properties[index];
        
        const char *name = property_getName(property);
        if (strcmp(selectorName, name) == 0) {
            *isGetter = YES;
            return @(name);
        }
        
        const char *getter = property_copyAttributeValue(property, "G");
        if (getter && strcmp(selectorName, getter) == 0) {
            *isGetter = YES;
            return @(name);
        }
        
        const char *setter = [self _setterName:name];
        int result = strcmp(selectorName, setter);
        free((void *)setter);
        
        if (result == 0) return @(name);
        
        setter = property_copyAttributeValue(property, "S");
        if (setter && strcmp(selectorName, setter) == 0) {
            return @(name);
        }
    }
    return nil;
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

- (JSValue *)_forwardProperty:(NSString *)property invocation:(NSInvocation *)invocation isGetter:(BOOL)isGetter{
    JSValue *javaScriptObject = self.javaScriptObject;
    JSContext *context = self.javaScriptContext;
    
    NSArray *arguments = MDJSImportBoxValues(context, invocation);
    
    if ([javaScriptObject isUndefined] || [javaScriptObject isNull]) return javaScriptObject;
    
    if (isGetter) return [javaScriptObject valueForProperty:property];
    else [javaScriptObject setValue:arguments.firstObject forProperty:property];
    
    return [JSValue valueWithUndefinedInContext:context];
}

- (JSValue *)_forwardFunction:(NSString *)function invocation:(NSInvocation *)invocation{
    JSValue *javaScriptObject = self.javaScriptObject;
    JSContext *context = self.javaScriptContext;
    
    NSArray *arguments = MDJSImportBoxValues(context, invocation);
    
    if ([javaScriptObject isUndefined] || [javaScriptObject isNull]) return javaScriptObject;
    return [javaScriptObject invokeMethod:function withArguments:arguments];
}

- (void)_invokeInvocation:(NSInvocation *)invocation value:(JSValue *)value{
    BOOL isNull = value.isUndefined || value.isNull;
    const char *type = invocation.methodSignature.methodReturnType;
    NSUInteger length = invocation.methodSignature.methodReturnLength;
    
    if (*type == '@') {
        JSContextRef context = value.context.JSGlobalContextRef;
        JSObjectRef objct = JSValueToObject(context, value.JSValueRef, NULL);
        if (!isNull && !JSObjectIsFunction(context, objct)) {
            if (value.isString) {
                NSString *string = value.toString;
                [invocation setReturnValue:&string];
            } else if (value.isNumber) {
                id object = value.toNumber;
                [invocation setReturnValue:&object];
            } else {
                [invocation setReturnValue:&value];
            }
        }
    } else if (*type == '{'){
        if (strcmp(type, @encode(CGPoint)) == 0) {
            CGPoint point = value.toPoint;
            [invocation setReturnValue:&point];
        } else if (strcmp(type, @encode(CGSize)) == 0) {
            CGSize size = value.toSize;
            [invocation setReturnValue:&size];
        } else if (strcmp(type, @encode(NSRange)) == 0) {
            NSRange range = value.toRange;
            [invocation setReturnValue:&range];
        } else if (strcmp(type, @encode(CGRect)) == 0) {
            CGRect rect = value.toRect;
            [invocation setReturnValue:&rect];
        } else {
            id obj = value.toObject;
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
        }
    } else if (*type == *@encode(int) ||
               *type == *@encode(char) ||
               *type == *@encode(short) ||
               *type == *@encode(long) ||
               *type == *@encode(long long) ||
               *type == *@encode(bool)) {
        long long result = isNull ? 0 : value.toNumber.longLongValue;
        [invocation setReturnValue:&result];
    } else if (*type == *@encode(unsigned int) ||
               *type == *@encode(unsigned char) ||
               *type == *@encode(unsigned short) ||
               *type == *@encode(unsigned long) ||
               *type == *@encode(unsigned long long)) {
        
        unsigned long long result = isNull ? 0 : value.toNumber.unsignedLongLongValue;
        [invocation setReturnValue:&result];
    } else if (*type == *@encode(double) || *type == *@encode(float)) {
        
        double doubleValue = isNull ? 0 : value.toNumber.doubleValue;
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
    BOOL isProperty = NO, isGetter = NO;
    NSString *name = [self _functionForSelector:anInvocation.selector isProperty:&isProperty isGetter:&isGetter];
    if (name.length) {
        JSValue *value = nil;
        if (isProperty) value = [self _forwardProperty:name invocation:anInvocation isGetter:isGetter];
        else value = [self _forwardFunction:name invocation:anInvocation];
        
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

- (JSValue *)invokeValue:(JSValue *)value method:(NSString *)method arguments:(NSArray<JSValue *> *)arguments;{
    if (_context) return [_context _invokeValue:value method:method arguments:arguments];
    else return [value invokeMethod:method withArguments:arguments];
}

- (JSValue *)evaluateScript:(NSString *)script{
    if (_context) return [_context _evaluateScript:script];
    else return [_javaScriptContext evaluateScript:script];
}

@end

@implementation MDJSStringImport

- (instancetype)initWithJavaScript:(NSString *)javaScript protocol:(Protocol *)protocol type:(MDJSExportInjectType)type;{
    NSParameterAssert(javaScript.length);
    if (self = [super initWithProtocol:protocol type:type]) {
        _javaScript = javaScript.copy;
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data protocol:(Protocol *)protocol type:(MDJSExportInjectType)type;{
    NSString *javaScript = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [self initWithJavaScript:javaScript protocol:protocol type:type];
}

- (instancetype)initWithFilePath:(NSString *)filePath protocol:(Protocol *)protocol type:(MDJSExportInjectType)type;{
    NSError *error = nil;
    NSString *javaScript = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if (error) return nil;
    
    return [self initWithJavaScript:javaScript protocol:protocol type:type];
}

- (instancetype)initWithProtocol:(Protocol *)protocol type:(MDJSExportInjectType)type{
    return [self initWithJavaScript:nil protocol:protocol type:type];
}

#pragma mark - protected

- (void)injectExportForContext:(JSContext *)context type:(MDJSExportInjectType)type{
    [self evaluateScript:_javaScript];
}

- (void)dealloc{
    _javaScript = nil;
}

@end

@implementation MDJSObjectImport

- (instancetype)initWithKeyPath:(NSString *)keyPath protocol:(Protocol *)protocol type:(MDJSExportInjectType)type{
    if (self = [super initWithProtocol:protocol type:type]) {
        _keyPath = keyPath.copy;
    }
    return self;
}

- (instancetype)initWithObject:(JSValue *)object protocol:(Protocol *)protocol;{
    if (self = [super initWithProtocol:protocol type:0]) {
        _referencedObject = object;
    }
    return self;
}

- (instancetype)initWithProtocol:(Protocol *)protocol type:(MDJSExportInjectType)type{
    return [self initWithKeyPath:nil protocol:protocol type:type];
}

- (void)dealloc{
    _keyPath = nil;
}

#pragma mark - accessor

- (JSValue *)javaScriptObject{
    JSValue *value = _referencedObject ?: self.javaScriptContext.globalObject;
    NSArray<NSString *> *keys = [_keyPath componentsSeparatedByString:@"."];
    for (NSString *key in keys) {
        value = [value objectForKeyedSubscript:key];
    }
    return value ?: [super javaScriptObject];
}

@end

@implementation MDJSBlockImport

- (instancetype)initWithBlock:(void (^)(JSContext *context))block type:(MDJSExportInjectType)type;{
    NSParameterAssert(block);
    if (self = [super initWithProtocol:@protocol(MDJSImport) type:type]) {
        _block = [block copy];
    }
    return self;
}

- (instancetype)initWithProtocol:(Protocol *)protocol type:(MDJSExportInjectType)type{
    return [self initWithBlock:nil type:type];
}

#pragma mark - protected

- (void)injectExportForContext:(JSContext *)context type:(MDJSExportInjectType)type{
    [self evaluateScript:@""];
    _block(context);
}

- (void)dealloc{
    _block = nil;
}

@end

