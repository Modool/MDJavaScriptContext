//
//  MDJSContext+Private.h
//  MDJavaScriptContext
//
//  Created by xulinfeng on 2018/5/22.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDJSContext.h"

@interface MDJSContext ()<UIWebViewDelegate>

@property (nonatomic, weak) UIWebView *webView;

@property (nonatomic, strong) NSMutableDictionary<NSString *, MDJSExport *> *mutableExports;
@property (nonatomic, strong) NSMutableArray<MDJSImport *> *mutableImports;

- (instancetype)initWithWebView:(UIWebView *)webView;

@end

@interface UIWebView (JSContext)

@property (nonatomic, strong, readonly) JSContext *javaScriptContext;

@end
