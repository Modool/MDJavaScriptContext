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

@property (nonatomic, copy, readonly) NSArray<MDJSExport *> *exports;
@property (nonatomic, copy, readonly) NSArray<MDJSImport *> *imports;

- (BOOL)addExport:(MDJSExport *)export_;
- (BOOL)removeExport:(MDJSExport *)export_;

- (BOOL)addImport:(MDJSImport *)import;
- (BOOL)removeImport:(MDJSImport *)import;

@end
