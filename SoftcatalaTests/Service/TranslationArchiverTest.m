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
#import "LanguageDirection.h"
#import "Language.h"

@interface TranslationArchiverTest : XCTestCase

@end

@implementation TranslationArchiverTest
{
    Language *cat;
    Language *es;
    LanguageDirection *languageDirection;
    Translation *translation;

}
- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    cat = [[Language alloc] initWithCode:@"cat" andName:@"català"];
    es = [[Language alloc] initWithCode:@"es" andName:@"castellà"];
    languageDirection = [[LanguageDirection alloc] initWithSourceLanguage:cat andDestinationLanguage:es];
    translation = [[Translation alloc] initWithSourceText:@"bon dia" translationText:@"buenos días" languageDirection:languageDirection isFavorite:YES];
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
    [self removeArchive];

    TranslationArchiver *archiver = [[TranslationArchiver alloc] init];
    [archiver addTranslation:translation];
    
    NSInteger translationsCount = archiver.numberOfTranslations;

    XCTAssertEqual(translationsCount, 1);

    archiver = nil;
    archiver = [[TranslationArchiver alloc] init];

    translationsCount = archiver.numberOfTranslations;

    XCTAssertEqual(translationsCount, 1);

}

- (void)testCannotSaveTwoEqualObjects
{
    [self removeArchive];
    
    TranslationArchiver *archiver = [[TranslationArchiver alloc] init];
    [archiver addTranslation:translation];

    NSInteger translationsCount = archiver.numberOfTranslations;
    XCTAssertEqual(translationsCount, 1);
    
    LanguageDirection *langDirection = [[LanguageDirection alloc] initWithSourceLanguage:cat andDestinationLanguage:es];
    Translation *newTranslation = [[Translation alloc] initWithSourceText:@"bon dia" translationText:@"buenos días" languageDirection:langDirection isFavorite:YES];

    [archiver addTranslation:newTranslation];
    
    translationsCount = archiver.numberOfTranslations;
    XCTAssertEqual(translationsCount, 1);
    
}

- (void)testCanRemoveATranslationFromArchiver
{
    [self removeArchive];

    Translation *translationRemove = mock([Translation class]);
    TranslationArchiver *archiver = [[TranslationArchiver alloc] init];

    [archiver addTranslation:translationRemove];
    XCTAssertEqual(archiver.numberOfTranslations, 1);

    [archiver removeTranslation:translationRemove];
    XCTAssertEqual(archiver.numberOfTranslations, 0);

}

- (void)testCanUpdateTranslationFromArchiver
{
    [self removeArchive];
    TranslationArchiver *archiver = [[TranslationArchiver alloc] init];
    
    [archiver addTranslation:translation];
    XCTAssertEqual(archiver.numberOfTranslations, 1);
    
    Translation *savedTranslation = [archiver.translations firstObject];
    XCTAssertTrue(savedTranslation.favourite);
    
    savedTranslation.favourite = NO;
    [archiver updateTranslation:translation];
    
    archiver = nil;
    archiver = [[TranslationArchiver alloc] init];
    Translation *updatedTranslation = [archiver.translations firstObject];
    XCTAssertFalse(updatedTranslation.favourite);
    
}

- (void)removeArchive
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileApp = [documentsDirectory stringByAppendingPathComponent:@"translations.db"];
    [[NSFileManager defaultManager] removeItemAtPath:fileApp error:nil];

}
@end
