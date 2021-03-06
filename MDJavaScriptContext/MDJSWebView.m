//
//  UIWebView+MDJSContext.m
//  MDJavaScriptContext
//
//  Created by xulinfeng on 2018/5/21.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <objc/runtime.h>
#import "MDJSWebView.h"

#import "MDJSContext+Private.h"
#import "MDJSWebViewDelegateWrapper.h"

@interface MDJSWebView ()<UIWebViewDelegate>

@property (nonatomic, strong) MDJSContext *context;

@property (nonatomic, strong) MDJSWebViewDelegateWrapper *wrapper;

@end

@implementation MDJSWebView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self initialize];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize{
    _context = [[MDJSContext alloc] initWithWebView:self];
    _wrapper = [[MDJSWebViewDelegateWrapper alloc] initWithContext:_context webView:self];
    
    super.delegate = _wrapper;
}

- (void)setDelegate:(id<UIWebViewDelegate>)delegate{
    _wrapper.delegate = delegate;
}

@end
