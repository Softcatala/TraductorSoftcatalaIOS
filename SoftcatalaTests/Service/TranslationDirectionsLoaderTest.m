//
//  TranslationDirectionsLoaderTest.m
//  Softcatala
//
//  Created by marcos on 01/03/14.
//  Copyright (c) 2014 Marcos Grau. All rights reserved.
//
#define MOCKITO_SHORTHAND
#import <OCMockitoIOS/OCMockitoIOS.h>

#import <XCTest/XCTest.h>
#import "TranslationDirectionLoader.h"

@interface TranslationDirectionsLoaderTest : XCTestCase

@end

@implementation TranslationDirectionsLoaderTest

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

- (void)testLoadTranslationsDirection
{
    TranslationDirectionLoader *loader = [[TranslationDirectionLoader alloc] init];
    XCTAssertNotNil(loader);

    NSArray *translationDirectionList = [loader loadAllCombinations];
    XCTAssertNotNil(translationDirectionList);
}
@end
