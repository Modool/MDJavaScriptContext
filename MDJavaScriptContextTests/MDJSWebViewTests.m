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

#import "MDJSImport+Additions.h"

@interface MDJSWebViewTests : XCTestCase<UIWebViewDelegate>

@property (nonatomic, strong, readonly) MDJSWebView *webView;

@property (nonatomic, strong, readonly) MDJSImport<MDJSWindow> *window;
@property (nonatomic, strong, readonly) MDJSImport<MDJSDocument> *document;
@property (nonatomic, strong, readonly) MDJSImport<MDJSHistory> *history;
@property (nonatomic, strong, readonly) MDJSImport<MDJSLocation> *location;
@property (nonatomic, strong, readonly) MDJSImport<MDJSNavigator> *navigator;
@property (nonatomic, strong, readonly) MDJSImport<MDJSScreen> *screen;

@end

@implementation MDJSWebViewTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _webView = [[MDJSWebView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    XCTAssertNotNil(_webView.context);
    XCTAssertTrue([_webView.delegate isKindOfClass:MDJSWebViewDelegateWrapper.class]);
    
    _window = MDJSImport.window;
    _document = MDJSImport.document;
    _history = MDJSImport.history;
    _location = MDJSImport.location;
    _navigator = MDJSImport.navigator;
    _screen = MDJSImport.screen;
    
    [_webView.context addImport:_window];
    [_webView.context addImport:_document];
    [_webView.context addImport:_history];
    [_webView.context addImport:_location];
    [_webView.context addImport:_navigator];
    [_webView.context addImport:_screen];
    
    NSString *filepath = [[NSBundle bundleForClass:self.class] pathForResource:@"test" ofType:@"html"];
    NSString *html = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil];
    [_webView loadHTMLString:html baseURL:[NSURL URLWithString:@"http://www.baidu.com"]];
}

- (void)testSetDelegate {
    _webView.delegate = self;
    
    MDJSWebViewDelegateWrapper *wrapper = _webView.delegate;
    
    XCTAssertEqual(wrapper.delegate, self);
}

- (void)testWindow{
    JSValue<MDJSDocument> *document = _window.document;
    
    XCTAssertTrue(document && !document.isUndefined && !document.isNull);
}

- (void)testDocument{
    NSString *URI = _document.baseURI;
    
    XCTAssertNotNil(URI);
}

- (void)testHistory{
    NSUInteger length = _history.length;
    
    XCTAssertTrue(length > 0);
}

- (void)testLocation{
    NSString *href = _location.href;
    
    XCTAssertNotNil(href);
}

- (void)testNavigator{
    NSString *userAgent = _navigator.userAgent;
    
    XCTAssertNotNil(userAgent);
}

- (void)testScreen{
    CGFloat width = _screen.availWidth;
    
    XCTAssertNotEqual(width, 0);
}

@end
