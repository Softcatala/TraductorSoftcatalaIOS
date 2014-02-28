//
// Created by Marcos Grau on 28/02/14.
// Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#import "TranslationArchiver.h"
#import "Translation.h"

@interface TranslationArchiver()

    @property(nonatomic, strong) NSMutableArray *translations;

@end

@implementation TranslationArchiver {

}

- (id)init {
    self = [super init];

    if (self)
    {
        _translations = [[NSMutableArray alloc] init];
    }

    return self;
}
- (void)addTranslation:(Translation *)translation {

    [_translations addObject:translation];

}

- (NSInteger)numberOfTranslations {
    return _translations.count;
}

- (void)removeTranslation:(Translation *)translation {
    [_translations removeObject:translation];
}
@end