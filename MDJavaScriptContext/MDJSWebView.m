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

@interface MDJSWebView ()

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
    _context = [[MDJSContext alloc] init];
    _wrapper = [[MDJSWebViewDelegateWrapper alloc] initWithContext:_context];
    
    super.delegate = _wrapper;
}

- (void)setDelegate:(id<UIWebViewDelegate>)delegate{
    _wrapper.delegate = delegate;
}

@end
