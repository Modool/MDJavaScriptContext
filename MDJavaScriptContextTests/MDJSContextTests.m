//
//  MDJSContextTests.m
//  MDJavaScriptContextTests
//
//  Created by xulinfeng on 2018/5/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MDJSContext.h"
#import "MDJSContext+Private.h"

@protocol MDJSContextTestExport <JSExport>
@end

@interface MDJSContextTestExport : MDJSExport <MDJSContextTestExport>
@end

@implementation MDJSContextTestExport
@end

@protocol MDJSContextTestImport <MDJSImport>
@end

@interface MDJSContextTests : XCTestCase

@property (nonatomic, strong, readonly) MDJSContext *context;

@property (nonatomic, strong, readonly) MDJSContextTestExport *export;
@property (nonatomic, strong, readonly) MDJSImport<MDJSContextTestImport> *import;

@end

@implementation MDJSContextTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _context = [[MDJSContext alloc] init];
    _context.javaScriptContext = [[JSContext alloc] init];
}

- (void)tearDown{
    [super tearDown];
    
    _context = nil;
    _export = nil;
    _import = nil;
}

- (void)testAddExport {
    _export = [[MDJSContextTestExport alloc] initWithName:@"test" type:MDJSExportInjectTypeAfterLoading];
    [_context addExport:_export];
    
    XCTAssertTrue([_context.mutableExports.allValues containsObject:_export]);
}

- (void)testRemoveExport {
    [_context removeExport:_export];
    
    XCTAssertFalse([_context.mutableExports.allValues containsObject:_export]);
}

- (void)testAddImport {
    _import = MDJSImportAlloc(MDJSImport, MDJSContextTestImport);
    [_context addImport:_import];
    
    XCTAssertTrue([_context.mutableImports containsObject:_import]);
}

- (void)testRemoveImport {
    [_context removeImport:_import];
    
    XCTAssertFalse([_context.mutableImports containsObject:_import]);
}

- (void)testInjectExports{
    _export = [[MDJSContextTestExport alloc] initWithName:@"test" type:MDJSExportInjectTypeAfterLoading];
    [_context addExport:_export];
    
    [_context _injectExportsToContext:_context.javaScriptContext type:MDJSExportInjectTypeAfterLoading];
    
    JSValue *value = [_context.javaScriptContext evaluateScript:@"test"];
    
    XCTAssertNotNil(value);
    XCTAssertTrue([value.toObject isKindOfClass:MDJSContextTestExport.class]);
}

@end
