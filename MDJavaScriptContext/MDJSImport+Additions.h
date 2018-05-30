//
//  MDJSImport+Additions.h
//  MDJavaScriptContext
//
//  Created by xulinfeng on 2018/5/30.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <MDJavaScriptContext/MDJavaScriptContext.h>

@protocol MDJSWindow, MDJSDocument, MDJSHistory, MDJSLocation, MDJSNavigator, MDJSScreen;
@interface MDJSImport (MDJSInjectString)

+ (instancetype)importWithJavaScript:(NSString *)javaScript protocol:(Protocol *)protocol type:(MDJSExportInjectType)type;
+ (instancetype)importWithData:(NSData *)data protocol:(Protocol *)protocol type:(MDJSExportInjectType)type;
+ (instancetype)importWithFilePath:(NSString *)filePath protocol:(Protocol *)protocol type:(MDJSExportInjectType)type;

@end

@interface MDJSImport (MDJSObject)

+ (instancetype)importWithKeyPath:(NSString *)keyPath protocol:(Protocol *)protocol type:(MDJSExportInjectType)type;
+ (instancetype)importWithObject:(JSValue *)object protocol:(Protocol *)protocol;

@end

@interface MDJSImport (MDJSWindow)

+ (MDJSImport<MDJSWindow> *)window;

+ (MDJSImport<MDJSWindow> *)openerWindow;
+ (MDJSImport<MDJSWindow> *)parentWindow;
+ (MDJSImport<MDJSWindow> *)topWindow;

@end

@interface MDJSImport (MDJSDocument)

+ (MDJSImport<MDJSDocument> *)document;

@end

@interface MDJSImport (MDJSHistory)

+ (MDJSImport<MDJSHistory> *)history;

@end

@interface MDJSImport (MDJSLocation)

+ (MDJSImport<MDJSLocation> *)location;

@end

@interface MDJSImport (MDJSNavigator)

+ (MDJSImport<MDJSNavigator> *)navigator;

@end

@interface MDJSImport (MDJSScreen)

+ (MDJSImport<MDJSScreen> *)screen;

@end

@interface JSValue (MDJSObject)

- (id /* MDJSImport * */)toObjectImportWithProtocol:(Protocol *)protocol;

@end
