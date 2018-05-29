//
//  MDJSImport.h
//  MDJavaScriptContext
//
//  Created by xulinfeng on 2018/5/21.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "MDJSExport.h"

#ifndef __MDJSImportAs__
#define __MDJSImportAs__

#define MDJSImportAlloc(CLASS, PROTOCOL)            [CLASS<PROTOCOL> importWithProtocol:@protocol(PROTOCOL) type:MDJSExportInjectTypeAll]
#define MDJSImportAlloc1(CLASS, PROTOCOL, TYPE)     [CLASS<PROTOCOL> importWithProtocol:@protocol(PROTOCOL) type:TYPE]

#define MDJSImportAs(PropertyName, Selector)  \
@optional Selector __MDJS_IMPORT_AS__##PropertyName:(id)argument; @optional Selector

#define MDJSImportGetterAs(GetterName, Selector) \
@optional Selector##__MDJS_IMPORT_AS__##GetterName; @optional Selector

#endif

NS_ASSUME_NONNULL_BEGIN

@protocol MDJSImport <NSObject>
@end

@interface MDJSImport : NSObject

@property (nonatomic, strong, readonly) Protocol *protocol;

@property (nonatomic, assign, readonly) MDJSExportInjectType injectType;

+ (instancetype)importWithProtocol:(Protocol *)protocol type:(MDJSExportInjectType)type;
- (instancetype)initWithProtocol:(Protocol *)protocol type:(MDJSExportInjectType)type NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
