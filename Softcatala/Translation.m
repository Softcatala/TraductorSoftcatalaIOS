//
//  Translation.m
//  Softcatala
//
//  Created by Marcos Grau on 24/02/14.
//  Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#import "Translation.h"
#import "LanguageDirection.h"

@implementation Translation


- (id)init
{
    return nil;
}

- (id)initWithSourceText:(NSString *)source translationText:(NSString *)translation languageDirection:(LanguageDirection *)languageDirection isFavorite:(BOOL)favourite
{
    self = [super init];
    if (self) {
        if (source && translation && languageDirection)
        {
        _source = source;
        _translation = translation;
        _languageDirection = languageDirection;
        _favourite = favourite;
        }
        else
        {
            return nil;
        }
    }
    return self;
}

- (void)reverse {
    [_languageDirection reverse];
    NSString *sourceCopy = [_source copy];
    _source = _translation;
    _translation = sourceCopy;
}
@end
