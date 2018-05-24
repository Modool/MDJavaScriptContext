//
//  MDJSContext.h
//  MDJavaScriptContext
//
//  Created by xulinfeng on 2018/5/21.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>

@class MDJSExport, MDJSImport;
@interface MDJSContext : NSObject

@property (nonatomic, strong, readonly) JSContext *javaScriptContext;

@property (nonatomic, copy, readonly) NSArray<MDJSExport<JSExport> *> *exports;
@property (nonatomic, copy, readonly) NSArray<MDJSImport *> *imports;

- (BOOL)addExport:(MDJSExport<JSExport> *)export_;
- (BOOL)removeExport:(MDJSExport<JSExport> *)export_;

- (BOOL)addImport:(MDJSImport *)import;
- (BOOL)removeImport:(MDJSImport *)import;

@end
