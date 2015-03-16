//
//  TranslationTest.m
//  Softcatala
//
//  Created by Marcos Grau on 24/02/14.
//  Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#define MOCKITO_SHORTHAND
#import <OCMockitoIOS/OCMockitoIOS.h>

#import <XCTest/XCTest.h>
#import "Translation.h"
#import "LanguageDirection.h"

@interface TranslationTest : XCTestCase

@end

@implementation TranslationTest

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
    Translation *translation = [[Translation alloc] init];
    XCTAssertNil(translation);
}

- (void)testCanCreateHistoricalItemWithCustomConstructor
{
    LanguageDirection *languageDirection = mock([LanguageDirection class]);
    Translation *translation = [[Translation alloc] initWithSourceText:@"bon dia" translationText:@"buenos días" languageDirection:languageDirection isFavorite:YES];
    XCTAssertNotNil(translation);
}

- (void)testCannotCreateHistoricalItemWithCustomConstructorWithNilArguments
{
    LanguageDirection *languageDirection = mock([LanguageDirection class]);
    Translation *translation = [[Translation alloc] initWithSourceText:nil translationText:@"buenos días" languageDirection:languageDirection isFavorite:YES];
    XCTAssertNil(translation);
}

- (void)testWhenReverseATranslationSourceAndDestinationMusteReverse
{
    LanguageDirection *languageDirection = mock([LanguageDirection class]);
    Translation *translation = [[Translation alloc] initWithSourceText:@"bon dia" translationText:@"buenos días" languageDirection:languageDirection isFavorite:YES];

    [translation reverse];

    XCTAssertEqual(translation.source , @"buenos días");
    XCTAssertEqual(translation.translation , @"bon dia");
}
@end
