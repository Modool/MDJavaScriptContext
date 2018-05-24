//
//  MDJSImportTests.m
//  MDJavaScriptContextTests
//
//  Created by xulinfeng on 2018/5/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MDJSImport+Private.h"

@protocol MDJSImportTestsImport <MDJSImport>

- (NSUInteger)function1;
- (NSUInteger)function2:(NSString *)arg;
- (NSUInteger)function3:(NSString *)arg1 :(NSString *)arg2;

MDJSImportAs(function4, - (NSUInteger)function4WithArg:(NSString *)arg);
MDJSImportAs(function5, - (NSUInteger)function5WithArg:(NSString *)arg1 arg2:(NSString *)arg2);

@end

@interface MDJSImportTests : XCTestCase

@property (nonatomic, strong, readonly) JSContext *context;
@property (nonatomic, strong, readonly) MDJSImport<MDJSImportTestsImport> *import;

@end

@implementation MDJSImportTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _context = [[JSContext alloc] init];
    _import = MDJSImportInstance(MDJSImport, MDJSImportTestsImport);
    _import.javaScriptContext = _context;
    
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSString *filepath = [bundle pathForResource:@"test" ofType:@"js"];
    NSString *javascript = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil];
    [_context evaluateScript:javascript];
}

- (void)testFunction1 {
    NSUInteger value = [_import function1];
    XCTAssertEqual(value, 1);
}

- (void)testFunction2 {
    NSUInteger value = [_import function2:@"2"];
    XCTAssertEqual(value, 2);
}

- (void)testFunction3 {
    NSUInteger value = [_import function3:@"3" :@""];
    XCTAssertEqual(value, 3);
}

- (void)testFunction4 {
    NSUInteger value = [_import function4WithArg:@"3"];
    XCTAssertEqual(value, 4);
}

- (void)testFunction5 {
    NSUInteger value = [_import function5WithArg:@"3" arg2:@""];
    XCTAssertEqual(value, 5);
}

@end
