//
//  HistorialItemTest.m
//  Softcatala
//
//  Created by Marcos Grau on 24/02/14.
//  Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#define MOCKITO_SHORTHAND
#import <OCMockitoIOS/OCMockitoIOS.h>

#import <XCTest/XCTest.h>
#import "HistoricalItem.h"

@interface HistorialItemTest : XCTestCase

@end

@implementation HistorialItemTest

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
    
    HistoricalItem *historicalItem = [[HistoricalItem alloc] initWithSourceText:@"bon dia" translationText:@"buenos días" languageDirection:@"ca|es" isFavorite:YES];
    XCTAssertNotNil(historicalItem);
}



@end
