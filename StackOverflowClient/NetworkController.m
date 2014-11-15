//
//  NetworkController.m
//  StackOverflowClient
//
//  Created by Sam Wong on 10/11/2014.
//  Copyright (c) 2014 Sam Wong. All rights reserved.
//

#import "NetworkController.h"
#import "Constant.h"

@interface NetworkController()

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionConfiguration *configuration;
//@property (nonatomic, strong) NSString *authToken;

@end

@implementation NetworkController

+ (id)sharedInstance {
    static NetworkController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    _configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:_configuration];
  
    return self;
}

- (void)dealloc {
}

//
//+ (void)setAuthToken:(NSString *)authToken {
//    [[self sharedInstance] setAuthToken:authToken];
//}

- (void)fetchQuestionsWithSearchTerm:(NSString *)searchText completionHandler: (void(^)(NSError *error, NSMutableArray *response))completionHandler {
    
    [self setConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
    [self setSession: [NSURLSession sessionWithConfiguration: _configuration]];
    
    NSString *urlString = nil;
    if (_authToken != nil) {
        //https://api.stackexchange.com/2.2/search/advanced?order=desc&sort=activity&tagged=cgrect&site=stackoverflow&access_token=BTRjRlsSb*GPERzvGPej0w))&key=n)5yDcr5enm7pgAvCAAcHQ((
        urlString = [NSString stringWithFormat:@"https://api.stackexchange.com/2.2/search/advanced?order=desc&sort=activity&tagged=%@&site=stackoverflow&access_token=%@&key=%@", searchText, _authToken, kPublicKey];
    } else {
        urlString = [NSString stringWithFormat:@"https://api.stackexchange.com/2.2/search/advanced?order=desc&sort=activity&tagged=%@&site=stackoverflow", searchText];
    }
    
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    NSURLSessionDataTask *dataTask = [_session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            NSInteger statusCode = [httpResponse statusCode];
            
            if (statusCode >= 200 && statusCode <= 299) {
                
                NSMutableArray *questions = [Question parseJSONDataIntoQuestions:data];
                
                NSLog(@"Number of questions found: %lu", (unsigned long)questions.count);
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    completionHandler(nil, questions);
                }];
            } else {
                NSLog(@"Bad Response - StatusCode %li", (long)statusCode);
            }
        }
    }];
    [dataTask resume];
    
}




//- (void)fetchQuestionsWithSearchTerm2:(NSString *)searchText completionHandler: (void(^)(NSError *error, NSMutableArray *response))completionHandler {
//    
//    [self setConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
//    [self setSession: [NSURLSession sessionWithConfiguration: _configuration]];
//    
//    NSString *urlString = [NSString stringWithFormat:@"https://api.stackexchange.com/2.2/search/advanced?order=desc&sort=activity&tagged=%@&site=stackoverflow", searchText];
//    NSURL *url = [[NSURL alloc] initWithString:urlString];
//    
//    NSURLSessionDataTask *dataTask = [_session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        if (error) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSLog(@"%@", error.localizedDescription);
//                completionHandler(nil, error);
//            });
//        } else {
//            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
//            NSInteger statusCode = [httpResponse statusCode];
//            
//            if (statusCode >= 200 && statusCode <= 299) {
//                
//                NSMutableArray *questions = [Question parseJSONDataIntoQuestions:data];
////                NSError *error = NSError errorWithDomain:<#(NSString *)#> code:<#(NSInteger)#> userInfo:<#(NSDictionary *)#>;
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    completionHandler(nil, questions);
//                });
//                
////                NSLog(@"Number of questions found: %lu", (unsigned long)questions.count);
////                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
////                    completionHandler(nil, questions);
////                }];
//            } else {
//                NSLog(@"Bad Response - StatusCode %li", (long)statusCode);
//            }
//        }
//    }];
//    [dataTask resume];
//    
//}


@end
