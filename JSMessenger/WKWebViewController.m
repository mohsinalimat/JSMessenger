//
//  WKWebViewController.m
//  JSMessenger
//
//  Created by cyan on 16/3/31.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "WKWebViewController.h"
#import <WebKit/WebKit.h>
#import "JSMessenger.h"

@interface WKWebViewController ()<WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation WKWebViewController

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"WKWebView";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self.webView loadHTMLString:html baseURL:[[NSBundle mainBundle] bundleURL]];
    [self.view addSubview:self.webView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 0, 200, 30);
    [btn setTitle:@"Send Message to JavaScript" forState:UIControlStateNormal];
    btn.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-88);
    [btn addTarget:self action:@selector(didClickNativeButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)didClickNativeButton:(UIButton *)sender {
    [self.webView msgSend:@"foobar" args:@[ @"Hello", @"WKWebView" ] returnBlock:^(id returnValue) {
        NSLog(@"Receive Response from JavaScript: %@", returnValue);
    }];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    [JSMessenger webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler();
                                                      }]];
    [self presentViewController:alertController animated:YES completion:^{}];
}

@end
