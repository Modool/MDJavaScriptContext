//
//  MDJSWebViewDelegateWrapper.m
//  MDJavaScriptContext
//
//  Created by xulinfeng on 2018/5/22.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "MDJSWebViewDelegateWrapper.h"

@implementation MDJSWebViewDelegateWrapper

+ (instancetype)wrapperWithContext:(id<UIWebViewDelegate>)context;{
    return [[self alloc] initWithContext:context];
}

- (instancetype)initWithContext:(id<UIWebViewDelegate>)context;{
    if (self = [super init])  {
        _context = context;
    }
    return self;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation{
    if ([anInvocation selector] == @selector(webView:shouldStartLoadWithRequest:navigationType:)) {
        [anInvocation invokeWithTarget:self.delegate];
    } else {
        if ([[self context] respondsToSelector:anInvocation.selector]) {
            NSInvocation *newInvocation = [self duplicateInvocation:anInvocation];
            [newInvocation invokeWithTarget:self.context];
        }
        if ([[self delegate] respondsToSelector:anInvocation.selector]) {
            [anInvocation invokeWithTarget:self.delegate];
        }
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector{
    return [[self delegate] respondsToSelector:aSelector] || [[self context] respondsToSelector:aSelector];
}

- (NSInvocation *)duplicateInvocation:(NSInvocation *)origInvocation {
    NSMethodSignature *methodSignature = [origInvocation methodSignature];
    
    NSInvocation *dupInvocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    [dupInvocation setSelector:[origInvocation selector]];
    
    NSUInteger i, count = [methodSignature numberOfArguments];
    for (i = 2; i < count; i++) {
        const char *type = [methodSignature getArgumentTypeAtIndex:i];
        if (*type == *@encode(BOOL)) {
            BOOL value;
            [origInvocation getArgument:&value atIndex:i];
            [dupInvocation setArgument:&value atIndex:i];
        } else if (*type == *@encode(char) || *type == *@encode(unsigned char)) {
            char value;
            [origInvocation getArgument:&value atIndex:i];
            [dupInvocation setArgument:&value atIndex:i];
        } else if (*type == *@encode(short) || *type == *@encode(unsigned short)) {
            short value;
            [origInvocation getArgument:&value atIndex:i];
            [dupInvocation setArgument:&value atIndex:i];
        } else if (*type == *@encode(int) || *type == *@encode(unsigned int)) {
            int value;
            [origInvocation getArgument:&value atIndex:i];
            [dupInvocation setArgument:&value atIndex:i];
        } else if (*type == *@encode(long) || *type == *@encode(unsigned long)) {
            long value;
            [origInvocation getArgument:&value atIndex:i];
            [dupInvocation setArgument:&value atIndex:i];
        } else if (*type == *@encode(long long) || *type == *@encode(unsigned long long)) {
            long long value;
            [origInvocation getArgument:&value atIndex:i];
            [dupInvocation setArgument:&value atIndex:i];
        } else if (*type == *@encode(double)) {
            double value;
            [origInvocation getArgument:&value atIndex:i];
            [dupInvocation setArgument:&value atIndex:i];
        } else if (*type == *@encode(float)) {
            float value;
            [origInvocation getArgument:&value atIndex:i];
            [dupInvocation setArgument:&value atIndex:i];
        } else if (*type == '@' || *type == '{') {
            void *value;
            [origInvocation getArgument:&value atIndex:i];
            [dupInvocation setArgument:&value atIndex:i];
        } else if (*type == '^') {
            void *block;
            [origInvocation getArgument:&block atIndex:i];
            [dupInvocation setArgument:&block atIndex:i];
        } else {
            NSString *selectorStr = NSStringFromSelector([origInvocation selector]);
            
            NSString *format = @"Argument %lu to method %@ - Type(%c) not supported";
            NSString *reason = [NSString stringWithFormat:format, (unsigned long)(i - 2), selectorStr, *type];
            
            [[NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil] raise];
        }
    }
    [dupInvocation retainArguments];
    return dupInvocation;
}

@end
