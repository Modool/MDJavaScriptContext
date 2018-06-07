//
//  ViewController.m
//  Demo
//
//  Created by xulinfeng on 2018/5/22.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import <MDJavaScriptContext/MDJavaScriptContext.h>
#import "ViewController.h"

@protocol TestExport <JSExport>

MDJSExportAs(set_test_message, - (void)setTestMessage:(NSString *)message);

MDJSExportAs(set_test_multiple_parameter, - (void)setTestParameter1:(NSString *)parameter1 parameter2:(NSString *)parameter2);

@end

@interface TestExport : MDJSExport<TestExport>

@end

@implementation TestExport

- (instancetype)init{
    return [super initWithName:@"test" type:MDJSExportInjectTypeAfterLoading];
}

- (void)setTestMessage:(NSString *)message{
    
}

- (void)setTestParameter1:(NSString *)parameter1 parameter2:(NSString *)parameter2{
    
}

@end

@protocol TextImport <MDJSImport>

MDJSImportAs(set_import_message, - (void)setImportMessage:(NSString *)message);
MDJSImportAs(set_import_multiple_parameter, - (void)setImportParameter1:(int)parameter1 parameter2:(int)parameter2);

MDJSImportNoneArgumentsAs(import_message, - (NSString *)importMessage);

MDJSImportNoneArgumentsAs(import_closure, - (JSValue *)importClosure);

@end

@interface ViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) IBOutlet MDJSWebView *webView;

@property (nonatomic, strong) TestExport<TestExport> *export;
@property (nonatomic, strong) MDJSImport<TextImport> *import;

@end

@implementation ViewController

- (void)loadView{
    [super loadView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"evaluate" style:UIBarButtonItemStyleDone target:self action:@selector(didClickEvaluate:)];
    
    self.webView = [[MDJSWebView alloc] initWithFrame:self.view.bounds];
    self.webView.delegate = self;
    
    [self.view addSubview:self.webView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    self.export = [[TestExport alloc] initWithName:@"test" type:MDJSExportInjectTypeAfterLoading];
//    self.import = MDJSImportAlloc(MDJSImport, TextImport);
//    
//    [self.webView.context addExport:self.export];
//    [self.webView.context addImport:self.import];
//    
    [self.webView loadHTMLString:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"] encoding:NSUTF8StringEncoding error:nil] baseURL:nil];
}

- (IBAction)didClickEvaluate:(id)sender{
//    id result = [self.import importMessage];
//    NSLog(@"%@", result);
//
//    [self.import setImportMessage:@"13242"];
//
//    JSValue *closure = [self.import importClosure];
//
//    [closure callWithArguments:@[@1, @2]];
    
    [[self import] setImportParameter1:1 parameter2:2];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView;{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView;{
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;{
    
}

@end
