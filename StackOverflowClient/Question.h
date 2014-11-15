//
//  Question.h
//  StackOverflowClient
//
//  Created by Sam Wong on 10/11/2014.
//  Copyright (c) 2014 Sam Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Question : NSObject

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *userName;

- (instancetype)initWithDictionary:(NSDictionary *) jsonDictionary;
+ (NSMutableArray *)parseJSONDataIntoQuestions:(NSData *) rawJSONData;

@end
