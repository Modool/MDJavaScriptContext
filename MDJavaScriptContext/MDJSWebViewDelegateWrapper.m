//
//  MDJSWebViewDelegateWrapper.m
//  MDJavaScriptContext
//
//  Created by xulinfeng on 2018/5/22.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "MDJSWebViewDelegateWrapper.h"

@implementation MDJSWebViewDelegateWrapper

+ (instancetype)wrapperWithContext:(id<UIWebViewDelegate>)context webView:(id<UIWebViewDelegate>)webView;{
    return [[self alloc] initWithContext:context webView:webView];
}

- (instancetype)initWithContext:(id<UIWebViewDelegate>)context webView:(id<UIWebViewDelegate>)webView;{
    if (self = [super init])  {
        _context = context;
        _webView = webView;
    }
    return self;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation{
    if ([anInvocation selector] == @selector(webView:shouldStartLoadWithRequest:navigationType:)) {
        [anInvocation invokeWithTarget:_delegate];
    } else {
        if ([_context respondsToSelector:anInvocation.selector]) {
            NSInvocation *newInvocation = [self duplicateInvocation:anInvocation];
            [newInvocation invokeWithTarget:_context];
        }
        if ([_webView respondsToSelector:anInvocation.selector]) {
            NSInvocation *newInvocation = [self duplicateInvocation:anInvocation];
            [newInvocation invokeWithTarget:_webView];
        }
        if ([_delegate respondsToSelector:anInvocation.selector]) {
            [anInvocation invokeWithTarget:_delegate];
        }
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector{
    return [_delegate respondsToSelector:aSelector] || [_context respondsToSelector:aSelector] || [_webView respondsToSelector:aSelector];
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
