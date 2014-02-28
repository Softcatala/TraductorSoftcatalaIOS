//
// Created by Marcos Grau on 28/02/14.
// Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#import "TranslationArchiver.h"
#import "Translation.h"
#import "LanguageDirection.h"
#import "Language.h"

@interface TranslationArchiver()

@property (nonatomic, strong) NSMutableArray *translations;
@property (nonatomic, copy) NSString *filePath;

@end

@implementation TranslationArchiver {

}

- (id)init {
    self = [super init];

    if (self)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        _filePath = [documentsDirectory stringByAppendingPathComponent:@"translations.db"];
        [self load];
    }

    return self;
}
- (void)addTranslation:(Translation *)translation {
    if ([self objectExists:translation] == NO)
    {
        [_translations addObject:translation];
        [self save];
    }
}

- (NSInteger)numberOfTranslations {
    return _translations.count;
}

- (void)removeTranslation:(Translation *)translation {
    [_translations removeObject:translation];
    [self save];
}

- (NSArray *)translations {
    return _translations;
}

- (void)updateTranslation:(Translation *)translation
{
    Translation *foundTranslation = [self findEqualTranslation:translation];
    if (foundTranslation != nil)
    {
        NSInteger indexFoundObject = [_translations indexOfObject:foundTranslation];
        [_translations replaceObjectAtIndex:indexFoundObject withObject:translation];
        [self save];
    }
}

#pragma mark Private methods

- (BOOL)objectExists:(Translation *)translation
{
    BOOL objectFound = YES;
    if ([self findEqualTranslation:translation] == nil) {
        objectFound = NO;
    }
    return objectFound;
}

- (Translation *)findEqualTranslation:(Translation *)translation
{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        Translation *currentTranslation = (Translation *)evaluatedObject;
        BOOL equalSource = [currentTranslation.source isEqualToString:translation.source];
        BOOL equalTranslation = [currentTranslation.translation isEqualToString:translation.translation];
        BOOL equalLanguageDirectionSourceCode = [currentTranslation.languageDirection.sourceLanguage.code isEqualToString:translation.languageDirection.sourceLanguage.code];
        BOOL equalLanguageDirectionDestinationCode = [currentTranslation.languageDirection.destinationLanguage.code isEqualToString:translation.languageDirection.destinationLanguage.code];
        if (equalSource && equalTranslation && equalLanguageDirectionSourceCode && equalLanguageDirectionDestinationCode)
        {
            return YES;
        }
        return NO;
    }];
    Translation *foundTranslation = nil;
    NSArray *filteredArray = [_translations filteredArrayUsingPredicate:predicate];
    if (filteredArray && [filteredArray count] > 0) {
        foundTranslation = [filteredArray firstObject];
    }
    return foundTranslation;
}

- (void)load
{
    _translations = [NSKeyedUnarchiver unarchiveObjectWithFile:_filePath];

    if (!_translations) {
        _translations = [[NSMutableArray alloc] init];
    }

}

- (void)save
{
    [NSKeyedArchiver archiveRootObject:_translations toFile:_filePath];
}
@end