//
//  MDJSWebViewTests.m
//  MDJavaScriptContextTests
//
//  Created by xulinfeng on 2018/5/24.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MDJSWebView.h"
#import "MDJSWebViewDelegateWrapper.h"

@interface MDJSWebViewTests : XCTestCase<UIWebViewDelegate>

@property (nonatomic, strong, readonly) MDJSWebView *webView;

@end

@implementation MDJSWebViewTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _webView = [[MDJSWebView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    XCTAssertNotNil(_webView.context);
    XCTAssertTrue([_webView.delegate isKindOfClass:MDJSWebViewDelegateWrapper.class]);
}

- (void)testSetDelegate {
    _webView.delegate = self;
    
    MDJSWebViewDelegateWrapper *wrapper = _webView.delegate;
    
    XCTAssertEqual(wrapper.delegate, self);
}

@end
