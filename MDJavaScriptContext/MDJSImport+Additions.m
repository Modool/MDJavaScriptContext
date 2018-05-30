//
//  MDJSImport+Additions.m
//  MDJavaScriptContext
//
//  Created by xulinfeng on 2018/5/30.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "MDJSImport+Additions.h"
#import "MDJSImport+Private.h"
#import "MDJSWindow.h"
#import "MDJSDocument.h"
#import "MDJSHistory.h"
#import "MDJSLocation.h"
#import "MDJSNavigator.h"
#import "MDJSScreen.h"

@implementation MDJSImport (MDJSInjectString)

+ (instancetype)importWithJavaScript:(NSString *)javaScript protocol:(Protocol *)protocol type:(MDJSExportInjectType)type;{
    return [[MDJSStringImport alloc] initWithJavaScript:javaScript protocol:protocol type:type];
}

+ (instancetype)importWithData:(NSData *)data protocol:(Protocol *)protocol type:(MDJSExportInjectType)type;{
    return [[MDJSStringImport alloc] initWithData:data protocol:protocol type:type];
}

+ (instancetype)importWithFilePath:(NSString *)filePath protocol:(Protocol *)protocol type:(MDJSExportInjectType)type;{
    return [[MDJSStringImport alloc] initWithFilePath:filePath protocol:protocol type:type];
}

@end

@implementation MDJSImport (MDJSObject)

+ (instancetype)importWithKeyPath:(NSString *)keyPath protocol:(Protocol *)protocol type:(MDJSExportInjectType)type;{
    return [[MDJSObjectImport alloc] initWithKeyPath:keyPath protocol:protocol type:type];
}

+ (instancetype)importWithObject:(JSValue *)object protocol:(Protocol *)protocol;{
    return [[MDJSObjectImport alloc] initWithObject:object protocol:protocol];
}

@end

@implementation MDJSImport (MDJSWindow)

+ (MDJSImport<MDJSWindow> *)window;{
    return [MDJSObjectImport<MDJSWindow> importWithKeyPath:@"window" protocol:@protocol(MDJSWindow) type:MDJSExportInjectTypeAll];
}

+ (MDJSImport<MDJSWindow> *)openerWindow;{
    return [MDJSObjectImport<MDJSWindow> importWithKeyPath:@"opener" protocol:@protocol(MDJSWindow) type:MDJSExportInjectTypeAll];
}

+ (MDJSImport<MDJSWindow> *)parentWindow;{
    return [MDJSObjectImport<MDJSWindow> importWithKeyPath:@"parent" protocol:@protocol(MDJSWindow) type:MDJSExportInjectTypeAll];
}

+ (MDJSImport<MDJSWindow> *)topWindow;{
    return [MDJSObjectImport<MDJSWindow> importWithKeyPath:@"top" protocol:@protocol(MDJSWindow) type:MDJSExportInjectTypeAll];
}

@end

@implementation MDJSImport (MDJSDocument)

+ (MDJSImport<MDJSDocument> *)document;{
    return [MDJSObjectImport<MDJSDocument> importWithKeyPath:@"document" protocol:@protocol(MDJSDocument) type:MDJSExportInjectTypeAll];
}

@end

@implementation MDJSImport (MDJSHistory)

+ (MDJSImport<MDJSHistory> *)history;{
    return [MDJSObjectImport<MDJSHistory> importWithKeyPath:@"history" protocol:@protocol(MDJSHistory) type:MDJSExportInjectTypeAll];
}

@end

@implementation MDJSImport (MDJSLocation)

+ (MDJSImport<MDJSLocation> *)location;{
    return [MDJSObjectImport<MDJSLocation> importWithKeyPath:@"location" protocol:@protocol(MDJSLocation) type:MDJSExportInjectTypeAll];
}

@end

@implementation MDJSImport (MDJSNavigator)

+ (MDJSImport<MDJSNavigator> *)navigator;{
    return [MDJSObjectImport<MDJSNavigator> importWithKeyPath:@"navigator" protocol:@protocol(MDJSNavigator) type:MDJSExportInjectTypeAll];
}

@end

@implementation MDJSImport (MDJSScreen)

+ (MDJSImport<MDJSScreen> *)screen;{
    return [MDJSObjectImport<MDJSScreen> importWithKeyPath:@"screen" protocol:@protocol(MDJSScreen) type:MDJSExportInjectTypeAll];
}

@end

@implementation JSValue (MDJSObject)

- (MDJSImport *)toObjectImportWithProtocol:(Protocol *)protocol;{
    return [MDJSImport importWithObject:self protocol:protocol];
}

@end
