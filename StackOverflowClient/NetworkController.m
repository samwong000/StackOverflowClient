//
//  NetworkController.m
//  StackOverflowClient
//
//  Created by Sam Wong on 10/11/2014.
//  Copyright (c) 2014 Sam Wong. All rights reserved.
//

#import "NetworkController.h"

@interface NetworkController()
@property (nonatomic,strong) NSURLSession *session;
@property (nonatomic,strong) NSURLSessionConfiguration *configuration;
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
    
    return self;
}

- (void)dealloc {
    
}

- (void)fetchQuestionsWithSearchTerm:(NSString *)searchText completionHandler: (void(^)(NSError *error, NSMutableArray *response))completionHandler {
    
    [self setConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
    [self setSession: [NSURLSession sessionWithConfiguration: _configuration]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.stackexchange.com/2.2/search/advanced?order=desc&sort=activity&tagged=%@&site=stackoverflow", searchText];
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

@end