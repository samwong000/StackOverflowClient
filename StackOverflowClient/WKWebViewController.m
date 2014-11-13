//
//  WKWebViewController.m
//  StackOverflowClient
//
//  Created by Sam Wong on 12/11/2014.
//  Copyright (c) 2014 Sam Wong. All rights reserved.
//

#import "WKWebViewController.h"
#import <WebKit/WebKit.h>
#import "NetworkController.h"
#import "Constant.h"

//@interface WKWebViewController ()
//    WKWebView *webView;
//@end

@interface WKWebViewController () <WKNavigationDelegate> {
    WKWebView *webView;
}
@end

@implementation WKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSString *loginURL = [NSString stringWithFormat:@"@%?client_id=&redirect_url=%@&scope=read_inbox",koAuthURL,kClientId, koAuthDomain];
    NSString *loginURL = kLoginURL;
    NSURL *url = [[NSURL alloc] initWithString: loginURL];
    NSURLRequest *request = [NSURLRequest requestWithURL: url];
    
    [webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSURLRequest *request = navigationAction.request;
    NSURL *url = request.URL;
    
    if (request) {
        
        NSString *requestString = [url absoluteString];
        
        if ([requestString containsString:@"login_success"]) {
            NSArray *components = [requestString componentsSeparatedByString:@"="];
//            NSArray *tokenComponents = [requestString componentsSeparatedByString:@"&"];
            if ([components count] >1) {
                NSString *token = components[1];
                [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"oAuthToken"];
            }
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }

}



@end
