//
//  HistoricalItemTest.m
//  Softcatala
//
//  Created by Marcos Grau on 24/02/14.
//  Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#define MOCKITO_SHORTHAND
#import <OCMockitoIOS/OCMockitoIOS.h>

#import <XCTest/XCTest.h>
#import "HistoricalItem.h"
#import "LanguageDirection.h"

@interface HistoricalItemTest : XCTestCase

@end

@implementation HistoricalItemTest

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

- (void)testCannotCreateHistoricalItemWithDefaultConstructor
{
    HistoricalItem *historicalItem = [[HistoricalItem alloc] init];
    XCTAssertNil(historicalItem);
}

- (void)testCanCreateHistoricalItemWithCustomConstructor
{
    LanguageDirection *languageDirection = mock([LanguageDirection class]);
    HistoricalItem *historicalItem = [[HistoricalItem alloc] initWithSourceText:@"bon dia" translationText:@"buenos días" languageDirection:languageDirection isFavorite:YES];
    XCTAssertNotNil(historicalItem);
}

- (void)testCannotCreateHistoricalItemWithCustomConstructorWithNilArguments
{
    LanguageDirection *languageDirection = mock([LanguageDirection class]);
    HistoricalItem *historicalItem = [[HistoricalItem alloc] initWithSourceText:nil translationText:@"buenos días" languageDirection:languageDirection isFavorite:YES];
    XCTAssertNil(historicalItem);
}


@end
