//
//  Question.m
//  StackOverflowClient
//
//  Created by Sam Wong on 10/11/2014.
//  Copyright (c) 2014 Sam Wong. All rights reserved.
//

#import "Question.h"

@interface Question()

@end

@implementation Question

- (instancetype)initWithDictionary:(NSDictionary *) jsonDictionary {
    self = [super init];
    
    if (self) {
        self.userId = jsonDictionary[@"user_id"];
        self.title = jsonDictionary[@"title"];
    }
    return self;
}

+ (NSArray *)parseJSONDataIntoQuestions:(NSData *) rawJSONData {

    NSError *error = nil;
    NSMutableArray *questions = [[NSMutableArray alloc] init];
    
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:rawJSONData options:NSJSONReadingAllowFragments error:&error];

    for (NSDictionary *questionItem in jsonDictionary[@"items"]) {
        Question *questionObject = [[Question alloc] initWithDictionary: questionItem];
        
        [questions addObject:questionObject];
    }

    return questions;
};

@end
