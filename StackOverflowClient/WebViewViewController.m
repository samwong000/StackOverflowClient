//
//  WebViewViewController.m
//  StackOverflowClient
//
//  Created by Sam Wong on 11/11/2014.
//  Copyright (c) 2014 Sam Wong. All rights reserved.
//

#import "WebViewViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewViewController () <WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)cancelButtonPressed:(UIButton *)sender;
@end

@implementation WebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSString *publicKey = @"5Vpg3uTqCwAssGUjZx73wg((";
//    NSString *oAuthDomain = @"https://stackexchange.com/oauth/login_success";
    NSString *clientID = @"3197";
//    NSString *oAuthURL = @"https://stackexchange.com/oauth/dialog?";
    
    _webView.delegate = self;
    
    NSString *loginURL = [NSString stringWithFormat:@"https://stackexchange.com/oauth/dialog?%@&redirect_uri=https://stackexchange.com/oauth/login_success&scope=read_inbox", clientID];

    NSURL *url = [[NSURL alloc] initWithString: loginURL];
    NSURLRequest *request = [NSURLRequest requestWithURL: url];
    
    [_webView loadRequest:request];

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (request) {
        
        NSString *requestString = [request.URL absoluteString];
        
        if ([requestString containsString:@"login_success"]) {
            NSArray *components = [requestString componentsSeparatedByString:@"="];
            NSArray *tokenComponents = [requestString componentsSeparatedByString:@"&"];
            if ([tokenComponents count] >1) {
                NSString *token = tokenComponents[1];
                [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"oAuthToken"];
            }
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    
    return YES;

}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}
@end
