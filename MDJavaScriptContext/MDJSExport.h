//
//  MDJSExport.h
//  MDJavaScriptContext
//
//  Created by xulinfeng on 2018/5/21.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>

#ifndef MDJSExportAs
#define MDJSExportAs    JSExportAs
#endif

typedef NS_ENUM(NSUInteger, MDJSExportInjectType) {
    MDJSExportInjectTypeBeforeLoading   = 1 << 0,
    MDJSExportInjectTypeAfterLoading    = 1 << 1,
};

@interface MDJSExport : NSObject

@property (nonatomic, strong, readonly) NSString *name;

@property (nonatomic, assign, readonly) MDJSExportInjectType injectType;

+ (instancetype)exportWithName:(NSString *)name type:(MDJSExportInjectType)type;
- (instancetype)initWithName:(NSString *)name type:(MDJSExportInjectType)type NS_DESIGNATED_INITIALIZER;

@end
