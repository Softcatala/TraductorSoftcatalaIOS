//
//  HistoricalItem.m
//  Softcatala
//
//  Created by Marcos Grau on 24/02/14.
//  Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#import "HistoricalItem.h"
#import "LanguageDirection.h"

@implementation HistoricalItem


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
@end
