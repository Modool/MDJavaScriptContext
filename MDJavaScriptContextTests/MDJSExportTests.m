//
//  MDJSExportTests.m
//  MDJavaScriptContextTests
//
//  Created by xulinfeng on 2018/5/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MDJSExport+Private.h"

@protocol MDJSExportTestsExport <JSExport>

- (NSUInteger)method1;
- (NSUInteger)method1WithArg:(NSString *)arg;
- (NSUInteger)method1WithArg:(NSString *)arg1 arg2:(NSString *)arg2;

MDJSExportAs(method_2_arg_1, - (NSUInteger)method2WithArg:(NSString *)arg);
MDJSExportAs(method_2_arg_1_arg_2, - (NSUInteger)method2WithArg:(NSString *)arg1 arg2:(NSString *)arg2);

@end

@interface MDJSExportTestsExport : MDJSExport <MDJSExportTestsExport>

@end

@implementation MDJSExportTestsExport

- (NSUInteger)method1;{
    return 1;
}

- (NSUInteger)method1WithArg:(NSString *)arg;{
    return 2;
}

- (NSUInteger)method1WithArg:(NSString *)arg1 arg2:(NSString *)arg2;{
    return 3;
}

- (NSUInteger)method2WithArg:(NSString *)arg{
    return 4;
}

- (NSUInteger)method2WithArg:(NSString *)arg1 arg2:(NSString *)arg2{
    return 5;
}

- (NSUInteger)method3{
    return 6;
}

@end

@interface MDJSExportTests : XCTestCase

@property (nonatomic, strong, readonly) JSContext *context;
@property (nonatomic, strong, readonly) MDJSExportTestsExport *export;
@property (nonatomic, strong, readonly) MDJSExportTestsExport *subExport;

@end

@implementation MDJSExportTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    _context = [[JSContext alloc] init];
    _export = [[MDJSExportTestsExport alloc] initWithName:@"_export" type:MDJSExportInjectTypeAfterLoading];
    
    _subExport = [[MDJSExportTestsExport alloc] initWithName:@"_sub_export" type:MDJSExportInjectTypeAfterLoading];
    [_export addSubExport:_subExport];
    
    [_export injectExportForContext:_context type:MDJSExportInjectTypeAfterLoading];
    
    JSValue *value = [_context evaluateScript:@"_export"];
    XCTAssertTrue([value.toObject isKindOfClass:MDJSExportTestsExport.class]);
    
    value = [_context evaluateScript:@"_export._sub_export"];
    XCTAssertTrue([value.toObject isKindOfClass:MDJSExportTestsExport.class]);
}

- (void)test_method1 {
    JSValue *value = [_context evaluateScript:@"_export._sub_export.method1()"];
    XCTAssertEqual(value.toInt32, 1);
}

- (void)test_method1_arg {
    JSValue *value = [_context evaluateScript:@"_export._sub_export.method1WithArg(12312321)"];
    XCTAssertEqual(value.toInt32, 2);
}

- (void)test_method1_arg1_arg2;{
    JSValue *value = [_context evaluateScript:@"_export.method1WithArgArg2(12312321, 23121312)"];
    XCTAssertEqual(value.toInt32, 3);
}

- (void)test_method2_arg {
    JSValue *value = [_context evaluateScript:@"_export.method_2_arg_1(12312321)"];
    XCTAssertEqual(value.toInt32, 4);
}

- (void)test_method2_arg1_arg2;{
    JSValue *value = [_context evaluateScript:@"_export.method_2_arg_1_arg_2(12312321, 23121312)"];
    XCTAssertEqual(value.toInt32, 5);
}

@end
