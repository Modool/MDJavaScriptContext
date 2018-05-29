//
//  MDJSContext.h
//  MDJavaScriptContext
//
//  Created by xulinfeng on 2018/5/21.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

@class MDJSExport, MDJSImport;
@interface MDJSContext : NSObject

@property (nonatomic, strong, nullable, readonly) JSContext *javaScriptContext;

@property (nonatomic, copy, nullable, readonly) NSArray<MDJSExport<JSExport> *> *exports;
@property (nonatomic, copy, nullable, readonly) NSArray<MDJSImport *> *imports;

- (BOOL)addExport:(MDJSExport<JSExport> *)export;
- (BOOL)removeExport:(MDJSExport<JSExport> *)export;

- (BOOL)addImport:(MDJSImport *)import;
- (BOOL)removeImport:(MDJSImport *)import;

@end

NS_ASSUME_NONNULL_END
