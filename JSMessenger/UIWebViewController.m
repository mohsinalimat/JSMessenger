//
//  UIWebViewController.m
//  JSMessenger
//
//  Created by cyan on 16/4/1.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "UIWebViewController.h"
#import "JSMessenger.h"

@interface UIWebViewController()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation UIWebViewController

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"UIWebView";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.delegate = self;
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
    [self.webView msgSend:@"foobar" args:@[ @"Hello", @"UIWebView" ] returnBlock:^(id returnValue) {
        NSLog(@"Receive Response from JavaScript: %@", returnValue);
    }];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return [JSMessenger webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
}

@end
