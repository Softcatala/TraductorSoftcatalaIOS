//
//  TranslationServerTest.m
//  Softcatala
//
//  Created by marcos on 01/03/14.
//  Copyright (c) 2014 Marcos Grau. All rights reserved.
//
#define MOCKITO_SHORTHAND
#import <OCMockitoIOS/OCMockitoIOS.h>
#import "Nocilla.h"

#import <XCTest/XCTest.h>
#import "TranslationRequest.h"

@interface TranslationServerTest : XCTestCase

@end

@implementation TranslationServerTest

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    [[LSNocilla sharedInstance] start];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
    [[LSNocilla sharedInstance] stop];
}

- (void)testCanCreateTranslationRequest
{
    TranslationRequest *translationRequest = [[TranslationRequest alloc] init];
    XCTAssertNotNil(translationRequest);
}

- (void)testCanSendATranslationAnReceiveAGoodResponse
{
    stubRequest(@"POST", @"http://www.softcatala.org/apertium/json/translate").
            andReturn(200).
            withBody(@"{\"responseDetails\" : \"null\",\n"
            "  \"responseData\" : {\n"
            "    \"translatedText\" : \"bon dia\\n\"\n"
            "  },\n"
            "  \"responseStatus\" : 200}");

    TranslationRequest *translationRequest = [[TranslationRequest alloc] init];
    __block  BOOL requestCompleted = NO;
    __block NSString *translationText;
    [translationRequest postRequestWithText:@"buenos" andTextDirection:@"es|ca" success:^(NSString *translation){
        requestCompleted = YES;
        translationText = translation;
    } failure:^(NSError *error){
        requestCompleted = YES;
    }];

    while (requestCompleted == NO) {
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }

    NSLog(@"Translation: %@", translationText);
    XCTAssertNotNil(translationText);
}
@end
