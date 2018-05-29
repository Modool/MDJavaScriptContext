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

+ (instancetype)wrapperWithContext:(id<UIWebViewDelegate>)context;
- (instancetype)initWithContext:(id<UIWebViewDelegate>)context;

@end

NS_ASSUME_NONNULL_END
