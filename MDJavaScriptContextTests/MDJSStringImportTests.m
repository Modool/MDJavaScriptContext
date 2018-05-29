//
//  MDJSStringImportTests.m
//  MDJavaScriptContextTests
//
//  Created by xulinfeng on 2018/5/29.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MDJSContext.h"
#import "MDJSContext+Private.h"

#import "MDJSStringImport.h"

@protocol MDJSStringImportTestsImport <MDJSImport>

- (NSUInteger)function1;

@end

@interface MDJSStringImportTests : XCTestCase

@property (nonatomic, strong, readonly) MDJSContext *context;
@property (nonatomic, strong, readonly) MDJSStringImport<MDJSStringImportTestsImport> *import;

@end

@implementation MDJSStringImportTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _context = [[MDJSContext alloc] init];
    _context.javaScriptContext = [[JSContext alloc] init];
    
    NSString *filepath = [[NSBundle bundleForClass:self.class] pathForResource:@"test" ofType:@"js"];
    _import = [[MDJSStringImport<MDJSStringImportTestsImport> alloc] initWithFilePath:filepath protocol:@protocol(MDJSStringImportTestsImport) type:MDJSExportInjectTypeAll];
    
    [_context addImport:_import];
}

- (void)testFunction1 {
    NSUInteger value = [_import function1];
    XCTAssertEqual(value, 1);
}

@end
