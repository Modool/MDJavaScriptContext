//
//  MDJSImport.h
//  MDJavaScriptContext
//
//  Created by xulinfeng on 2018/5/21.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "MDJSExport.h"

#ifndef MDJSImportAs
#define MDJSImportAs

#define MDJSImportInstance(CLASS, PROTOCOL)     [CLASS<PROTOCOL> importWithProtocol:@protocol(PROTOCOL)]

#define MDJSImportMethodAs(PropertyName, Selector)  \
@optional Selector __MDJS_IMPORT_AS__##PropertyName:(id)argument; @optional Selector

#define MDJSImportPropertyAs(PropertyName, Selector) \
@optional Selector##__MDJS_IMPORT_AS__##PropertyName; @optional Selector

#endif

@interface MDJSImport : NSObject

@property (nonatomic, strong, readonly) Protocol *protocol;

+ (instancetype)importWithProtocol:(Protocol *)protocol;
- (instancetype)initWithProtocol:(Protocol *)protocol NS_DESIGNATED_INITIALIZER;

@end
