//
//  MDJSObjectImport.h
//  MDJavaScriptContext
//
//  Created by xulinfeng on 2018/5/29.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "MDJSImport.h"

NS_ASSUME_NONNULL_BEGIN

@interface MDJSObjectImport : MDJSImport

@property (nonatomic, copy, readonly) NSString *keyPath;

+ (instancetype)importWithProtocol:(Protocol *)protocol type:(MDJSExportInjectType)type NS_UNAVAILABLE;
- (instancetype)initWithProtocol:(Protocol *)protocol type:(MDJSExportInjectType)type NS_UNAVAILABLE;

+ (instancetype)importWithKeyPath:(NSString *)keyPath protocol:(Protocol *)protocol type:(MDJSExportInjectType)type;
- (instancetype)initWithKeyPath:(NSString *)keyPath protocol:(Protocol *)protocol type:(MDJSExportInjectType)type NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
