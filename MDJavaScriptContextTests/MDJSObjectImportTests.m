//
//  MDJSObjectImportTests.m
//  MDJavaScriptContextTests
//
//  Created by xulinfeng on 2018/5/29.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MDJSContext.h"
#import "MDJSContext+Private.h"
#import "MDJSImport+Private.h"

@protocol MDJSObjectImportTestsImport <MDJSImport>

- (NSUInteger)function6;

@end

@interface MDJSObjectImportTests : XCTestCase

@property (nonatomic, strong, readonly) MDJSContext *context;
@property (nonatomic, strong, readonly) MDJSObjectImport<MDJSObjectImportTestsImport> *import;

@end

@implementation MDJSObjectImportTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _context = [[MDJSContext alloc] init];
    _context.javaScriptContext = [[JSContext alloc] init];
    
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSString *filepath = [bundle pathForResource:@"test" ofType:@"js"];
    NSString *javaScript = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil];
    [_context.javaScriptContext evaluateScript:javaScript];
    
    _import = [[MDJSObjectImport<MDJSObjectImportTestsImport> alloc] initWithKeyPath:@"object_import.object_property"  protocol:@protocol(MDJSObjectImportTestsImport) type:MDJSExportInjectTypeAll];
    
    [_context addImport:_import];
}

- (void)testFunction1 {
    NSUInteger value = [_import function6];
    XCTAssertEqual(value, 6);
}

@end
