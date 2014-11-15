//
//  JSONTest.m
//  StackOverflowClient
//
//  Created by Sam Wong on 12/11/2014.
//  Copyright (c) 2014 Sam Wong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Question.h"

@interface JSONTest : XCTestCase

@end

@implementation JSONTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void) testQuestionJSON {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"questions" ofType:@"json"];
    XCTAssertNotNil(path, @"fail to locate questions.json file");
    
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    XCTAssertNotNil(jsonData, @"fail to load JSON file");
    
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    XCTAssertNotNil(jsonDict, @"jsonData is nil");
    
    NSArray *jsonArray = jsonDict[@"items"];
    XCTAssertTrue([jsonArray isKindOfClass:[NSArray class]], @"JSON file is not an array class");
    
//    NSArray *questionArray = [Question questionJSONArray: jsonArray] ;
//    XCTAssertEqual(questionArray.userId, @"3291506", @"question object value is not correct");
    


}


@end
