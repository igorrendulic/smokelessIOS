//
//  ViewController.m
//  smokeless
//
//  Created by Igor Test on 17/06/16.
//  Copyright © 2016 Igor Rendulic. All rights reserved.
//

#import "ViewController.h"
#import "Reachability.h"

NSString * destinationURL = @"https://project-5518000328915581804.firebaseapp.com/#/tabs/dash";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedRemoteMessage:) name:@"receivedRemoteMessage" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkIfWebLoaded:) name:@"checkIfWebLoaded" object:nil];
    
    // Do any additional setup after loading the view, typically from a nib.
    WKWebViewConfiguration *conf = [[WKWebViewConfiguration alloc] init];
    [conf.userContentController addScriptMessageHandler:self name:@"trackEvent"];
    _webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:conf];
    [_webView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
    
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    _progressView.center = self.view.center;
    _progressView.hidden = NO;
    [_progressView setProgress:0.0];
    
    [self.view addSubview:_progressView];
    [self.view addSubview:_viewLogButton];
    
    [self loadPage];
    
    
//    NSLog(@"TOKEN: %@", [[FIRInstanceID instanceID] token]);
}


- (void)loadPage {
    
    NSURL *url = [NSURL URLWithString:destinationURL];
    
    // NSURLRequestReturnCacheDataElseLoad
    NSURLRequest  *request = [NSURLRequest requestWithURL:url];
    
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
    _progressView.hidden = YES;
    NSLog(@"Navigation: %@", _webView.URL.absoluteString);
    // Optional data
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"redirect received");
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%s. Error %@",__func__,error);
    if (error.code == NSURLErrorCancelled) return;
    _progressView.hidden = YES;
    [self forceReload];
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%s. Error %@",__func__,error);
    [self forceReload];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void) receivedRemoteMessage:(NSNotification *)notification {
    if ([[notification name] isEqualToString:@"receivedRemoteMessage"]) {
        if (notification.userInfo) {
            [self showAlert:notification.userInfo[@"message"]];
        }
    }
}

- (void) checkIfWebLoaded:(NSNotification *) notification {
    NSLog(@"Called checkIfWebLoaded");
    if (_webView) {
        NSLog(@"webView exists");
        [_webView evaluateJavaScript:@"document.querySelector('div').innerHTML" completionHandler:^(id result, NSError * _Nullable error) {
            if (!result) {
                NSLog(@"Web not loaded! Fixing it! %@", error.localizedDescription);
                [self loadPage];
            }
        }];
    }
}

-(void) showAlert:(NSString *)message {
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"News"
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                                actionWithTitle:@"Ok"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                }];
    
    [alert addAction:okButton];

    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) forceReload {
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Error"
                                 message:@"Something went wrong. Please check you internet connection and press Retry"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"Retry"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle your yes please button action here
                                   [self loadPage];
                               }];
    
    [alert addAction:okButton];
    
    
    [self presentViewController:alert animated:YES completion:nil];
}
@end
