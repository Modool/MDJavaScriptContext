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

@property NSUInteger property1;

- (NSUInteger)function1;
- (NSUInteger)function2:(NSString *)arg;
- (NSUInteger)function3:(NSString *)arg1 :(NSString *)arg2;

MDJSImportAs(function4, - (NSUInteger)function4WithArg:(NSString *)arg);
MDJSImportAs(function5, - (NSUInteger)function5WithArg:(NSString *)arg1 arg2:(NSString *)arg2);

- (id)function6:(double)value;

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
    _context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        NSLog(@"context: %@, exception: %@", context, exception);
        context.exception = nil;
    };
    
    _import = MDJSImportAlloc(MDJSImport, MDJSImportTestsImport);
    
    _import.javaScriptContext = _context;
    
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSString *filepath = [bundle pathForResource:@"test" ofType:@"js"];
    NSString *javaScript = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil];
    [_context evaluateScript:javaScript];
}

- (void)testReadProperty1 {
    NSUInteger value = _import.property1;
    XCTAssertEqual(value, 10);
}

- (void)testWriteProperty1 {
    _import.property1 = 100;
    
    NSUInteger value = _import.property1;
    XCTAssertEqual(value, 100);
}

- (void)testProperty1Getter {
    NSUInteger value = [_import property1];
    XCTAssertEqual(value, 10);
}

- (void)testProperty1Setter {
    [_import setProperty1:100];
    
    NSUInteger value = _import.property1;
    XCTAssertEqual(value, 100);
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

- (void)testFunction6 {
    id value = [_import function6:100.22];
    XCTAssertTrue([value doubleValue] == 100.22);
}

@end
