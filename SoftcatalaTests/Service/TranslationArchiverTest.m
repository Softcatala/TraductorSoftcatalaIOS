//
//  TranslationArchiverTest.m
//  Softcatala
//
//  Created by Marcos Grau on 28/02/14.
//  Copyright (c) 2014 Marcos Grau. All rights reserved.
//
#define MOCKITO_SHORTHAND
#import <OCMockitoIOS/OCMockitoIOS.h>

#import <XCTest/XCTest.h>
#import "TranslationArchiver.h"
#import "Translation.h"

@interface TranslationArchiverTest : XCTestCase

@end

@implementation TranslationArchiverTest

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

- (void)testCanCreateATranslationArchiver
{
    TranslationArchiver *archiver = [[TranslationArchiver alloc] init];
    XCTAssertNotNil(archiver);
    
    NSArray *translationsList = [archiver translations];
    XCTAssertNotNil(translationsList);
}

- (void)testCanSaveATranslationInArchiver
{
    Translation *translation = mock([Translation class]);
    TranslationArchiver *archiver = [[TranslationArchiver alloc] init];

    [archiver addTranslation:translation];
    
    NSInteger translationsCount = archiver.numberOfTranslations;

    XCTAssertEqual(translationsCount, 1);
    
}

- (void)testCanRemoveATranslationFromArchiver
{
    Translation *translation = mock([Translation class]);
    TranslationArchiver *archiver = [[TranslationArchiver alloc] init];

    [archiver addTranslation:translation];
    XCTAssertEqual(archiver.numberOfTranslations, 1);

    [archiver removeTranslation:translation];
    XCTAssertEqual(archiver.numberOfTranslations, 0);

}

@end
