//
//  NetworkController.h
//  StackOverflowClient
//
//  Created by Sam Wong on 10/11/2014.
//  Copyright (c) 2014 Sam Wong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Question.h"

@interface NetworkController : NSObject

+ (id)sharedInstance;
+ (void)setAuthToken:(NSString *)authToken;

- (void)fetchQuestionsWithSearchTerm:(NSString *)searchText completionHandler: (void(^)(NSError *error, NSMutableArray *response))completionHandler;

@end
