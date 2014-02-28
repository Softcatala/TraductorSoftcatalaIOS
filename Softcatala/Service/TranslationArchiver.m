//
// Created by Marcos Grau on 28/02/14.
// Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#import "TranslationArchiver.h"
#import "Translation.h"

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

    [_translations addObject:translation];
    [self save];

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

#pragma mark Private methods

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