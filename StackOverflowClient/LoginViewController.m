//
//  LoginViewController.m
//  StackOverflowClient
//
//  Created by Sam Wong on 12/11/2014.
//  Copyright (c) 2014 Sam Wong. All rights reserved.
//

#import "LoginViewController.h"
#import <WebKit/WebKit.h>
#import "Constant.h"
#import "RootViewController.h"

@interface LoginViewController () <WKNavigationDelegate>
- (IBAction)loginButtonPressed:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginButtonPressed:(id)sender {
    // create webview here
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame];
    webView.navigationDelegate = self;
    
    NSURL *url = [[NSURL alloc] initWithString:kLoginURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    decisionHandler(WKNavigationActionPolicyAllow);
    
    NSURLRequest *request = navigationAction.request;
    NSURL *url = request.URL;
    NSString *urlDescription = url.description;
    
    if ([urlDescription containsString:@"access_token"] == YES) {
        NSArray *components = [urlDescription componentsSeparatedByString:@"="];
        
        if ([components count] >1) {
            NSString *token = components[1];
            // set user default value
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:koAuthToken];
            
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                     bundle: nil];
            UIWindow *window = [[UIApplication sharedApplication] keyWindow];
            
            id containerVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"CONTAINER_VC"];
            
            // reset the window.rootviewController to containVC,
            // no memory de-alloc for xib
            [UIView transitionWithView:window
                              duration:0.5
                               options:UIViewAnimationOptionTransitionFlipFromLeft
                            animations:^{ window.rootViewController = containerVC; }
                            completion:nil];
            
            // the following code will not clear memory for xib
//            id destinationVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"CONTAINER_VC"];
            //[self presentViewController:destinationVC animated:true completion:nil];

        }
    }
    
}

@end
