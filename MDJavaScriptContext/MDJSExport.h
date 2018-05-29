//
//  MDJSExport.h
//  MDJavaScriptContext
//
//  Created by xulinfeng on 2018/5/21.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>

#ifndef __MDJSExportAs__
#define __MDJSExportAs__
#define MDJSExportAs    JSExportAs
#endif

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MDJSExportInjectType) {
    MDJSExportInjectTypeInitializing = 1 << 0,
    MDJSExportInjectTypeStartLoading = 1 << 1,
    MDJSExportInjectTypeAfterLoading = 1 << 2,
    
    MDJSExportInjectTypeNone   = 0,
    MDJSExportInjectTypeAll    = MDJSExportInjectTypeInitializing | MDJSExportInjectTypeStartLoading | MDJSExportInjectTypeAfterLoading,
};

@interface MDJSExport : NSObject

@property (nonatomic, copy, readonly) NSString *name;

@property (nonatomic, copy, readonly) NSArray<MDJSExport<JSExport> *> *subExports;

@property (nonatomic, assign, readonly) MDJSExportInjectType injectType;

+ (instancetype)exportWithName:(NSString *)name type:(MDJSExportInjectType)type;
- (instancetype)initWithName:(NSString *)name type:(MDJSExportInjectType)type NS_DESIGNATED_INITIALIZER;

- (BOOL)addSubExport:(MDJSExport<JSExport> *)subExport;
- (BOOL)removeSubExport:(MDJSExport<JSExport> *)subExport;

@end

NS_ASSUME_NONNULL_END
