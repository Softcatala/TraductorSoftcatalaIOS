//
// Created by marcos on 24/02/14.
// Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#import "LanguageDirection.h"
#import "Language.h"


@implementation LanguageDirection
{

    Language *_sourceLanguage;
}

- (id)init
{
    return nil;
}

- (id)initWithSourceLanguage:(Language *)sourceLanguage andDestinationLanguage:(Language *)destinationLanguage {

    if (sourceLanguage == nil || destinationLanguage == nil)
        return nil;

    self = [super init];

    if (self)
    {
        _sourceLanguage = sourceLanguage;
        _destinationLanguage = destinationLanguage;
    }
    return self;
}

- (void)reverse {
    Language *sourceCopy = [[Language alloc] initWithCode:_sourceLanguage.code andName:_sourceLanguage.name];
    _sourceLanguage = [[Language alloc] initWithCode:_destinationLanguage.code andName:_destinationLanguage.name];
    _destinationLanguage = sourceCopy;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_sourceLanguage forKey:@"sourceLanguage"];
    [encoder encodeObject:_destinationLanguage forKey:@"destinationLanguage"];
}

- (id)initWithCoder:(NSCoder * )coder
{
    if (self = [super init])
    {
        _sourceLanguage = [coder decodeObjectForKey:@"sourceLanguage"];
        _destinationLanguage = [coder decodeObjectForKey:@"destinationLanguage"];
    }
    return self;
}

@end