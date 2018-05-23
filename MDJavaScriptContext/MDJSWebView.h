//
//  UIWebView+MDJSContext.h
//  MDJavaScriptContext
//
//  Created by xulinfeng on 2018/5/21.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MDJSContext;
@interface MDJSWebView : UIWebView

@property (nonatomic, strong, readonly) MDJSContext *context;

@end
