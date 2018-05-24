//
//  MDJSExport+Private.h
//  MDJavaScriptContext
//
//  Created by xulinfeng on 2018/5/22.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "MDJSExport.h"

@interface MDJSExport ()

@property (nonatomic, strong) NSString *name;
@property (nonatomic, weak) JSContext *javaScriptContext;

- (void)willInjectToContext:(JSContext *)context type:(MDJSExportInjectType)type;
- (void)didInjectToContext:(JSContext *)context type:(MDJSExportInjectType)type;

@end
