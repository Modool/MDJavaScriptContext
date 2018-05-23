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
        void *value;
        [origInvocation getArgument:&value atIndex:i];
        [dupInvocation setArgument:&value atIndex:i];
    }
    [dupInvocation retainArguments];
    return dupInvocation;
}

@end
