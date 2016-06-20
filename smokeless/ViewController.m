//
//  ViewController.m
//  smokeless
//
//  Created by Igor Test on 17/06/16.
//  Copyright © 2016 Igor Rendulic. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    WKWebViewConfiguration *conf = [[WKWebViewConfiguration alloc] init];
    [conf.userContentController addScriptMessageHandler:self name:@"trackEvent"];
    _webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:conf];
    [_webView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
    
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    _progressView.frame = CGRectMake(0, 0, self.view.frame.size.width, 20);
    
    NSURL *url = [NSURL URLWithString:@"https://project-5518000328915581804.firebaseapp.com"];
    //NSURL *url = [NSURL URLWithString:@"http://localhost:8100"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.view addSubview:_progressView];
    
    [_webView loadRequest:request];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if ([change[NSKeyValueChangeKindKey] integerValue] == NSKeyValueObservingOptionNew) {
            [_progressView setProgress:_webView.estimatedProgress animated:YES];
        }
        if (_webView.estimatedProgress == 1) {
            _progressView.hidden = YES;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    // Log out the message received
    if (message && [message.name isEqualToString:@"trackEvent"]) {
        NSString *name = [message.body objectForKey:@"name"];
        NSString *category = [message.body objectForKey:@"category"];
        [FIRAnalytics logEventWithName:name parameters:@{@"category":category}];
    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"%s",__func__);
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%s. Error %@",__func__,error);
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
