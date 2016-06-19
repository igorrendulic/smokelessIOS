//
//  ViewController.h
//  smokeless
//
//  Created by Igor Test on 17/06/16.
//  Copyright © 2016 Igor Rendulic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@import Firebase;

@interface ViewController : UIViewController <WKScriptMessageHandler,WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

