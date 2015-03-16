//
//  LanguageDirectionTest.m
//  Softcatala
//
//  Created by Marcos Grau on 28/02/14.
//  Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#define MOCKITO_SHORTHAND
#import <OCMockitoIOS/OCMockitoIOS.h>

#import <XCTest/XCTest.h>
#import "LanguageDirection.h"
#import "Language.h"

@interface LanguageDirectionTest : XCTestCase

@end

@implementation LanguageDirectionTest

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

- (void)testCannotCreateLanguageDirectionWithDefaultConstructor
{
    LanguageDirection *languageDirection = [[LanguageDirection alloc] init];
    XCTAssertNil(languageDirection);
}

- (void)testCannotCreateLanguageDirectionWithNilParametersInTheConstructor
{
    LanguageDirection *languageDirection = [[LanguageDirection alloc] initWithSourceLanguage:nil andDestinationLanguage:nil];
    XCTAssertNil(languageDirection);
}

- (void)testCanCreateLanguageDirection
{
    Language *sourceLanguage = mock([Language class]);
    Language *destinationLanguage = mock([Language class]);

    LanguageDirection *languageDirection = [[LanguageDirection alloc] initWithSourceLanguage:sourceLanguage andDestinationLanguage:destinationLanguage];
    XCTAssertNotNil(languageDirection);

    XCTAssertNotNil([languageDirection sourceLanguage]);
    XCTAssertNotNil([languageDirection destinationLanguage]);
}

- (void)testLanguageDirectionReverse
{
    Language *sourceLanguage = mock([Language class]);
    Language *destinationLanguage = mock([Language class]);

    [given([sourceLanguage code]) willReturn:@"ca"];
    [given([destinationLanguage code]) willReturn:@"en"];

    [given([sourceLanguage name]) willReturn:@"Català"];
    [given([destinationLanguage name]) willReturn:@"Anglés"];

    LanguageDirection *languageDirection = [[LanguageDirection alloc] initWithSourceLanguage:sourceLanguage andDestinationLanguage:destinationLanguage];

    XCTAssertEqual(languageDirection.sourceLanguage.code, @"ca");
    XCTAssertEqual(languageDirection.destinationLanguage.code, @"en");

    XCTAssertEqual(languageDirection.sourceLanguage.name, @"Català");
    XCTAssertEqual(languageDirection.destinationLanguage.name, @"Anglés");

    [languageDirection reverse];

    XCTAssertEqual(languageDirection.sourceLanguage.code, @"en");
    XCTAssertEqual(languageDirection.destinationLanguage.code, @"ca");
    XCTAssertEqual(languageDirection.sourceLanguage.name, @"Anglés");
    XCTAssertEqual(languageDirection.destinationLanguage.name, @"Català");

}
@end
