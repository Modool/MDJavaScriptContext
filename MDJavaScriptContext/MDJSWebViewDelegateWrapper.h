//
//  MDJSWebViewDelegateWrapper.h
//  MDJavaScriptContext
//
//  Created by xulinfeng on 2018/5/22.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDJSWebViewDelegateWrapper : NSObject <UIWebViewDelegate>

@property (nonatomic, weak, nullable) id<UIWebViewDelegate> delegate;

@property (nonatomic, weak, readonly) id<UIWebViewDelegate> context;

@property (nonatomic, weak, readonly) id<UIWebViewDelegate> webView;

+ (instancetype)wrapperWithContext:(id<UIWebViewDelegate>)context webView:(id<UIWebViewDelegate>)webView;
- (instancetype)initWithContext:(id<UIWebViewDelegate>)context webView:(id<UIWebViewDelegate>)webView;

@end

NS_ASSUME_NONNULL_END
