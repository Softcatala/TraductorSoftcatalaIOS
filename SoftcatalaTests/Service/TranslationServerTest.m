//
//  TranslationServerTest.m
//  Softcatala
//
//  Created by marcos on 01/03/14.
//  Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TranslationRequest.h"

@interface TranslationServerTest : XCTestCase

@end

@implementation TranslationServerTest

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testCanCreateTranslationRequest
{
    TranslationRequest *translationRequest = [[TranslationRequest alloc] init];
    XCTAssertNotNil(translationRequest);
}
@end
