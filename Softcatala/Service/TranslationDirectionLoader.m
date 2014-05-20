//
// Created by marcos on 01/03/14.
// Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#import "TranslationDirectionLoader.h"
#import "Language.h"
#import "LanguageDirection.h"


@implementation TranslationDirectionLoader {

}
- (NSArray *)loadAllCombinations {
    NSMutableArray *allCombinations = [[NSMutableArray alloc] init];

    Language *es = [[Language alloc] initWithCode:@"es" andName:NSLocalizedString(@"es", nil)];
    Language *ca = [[Language alloc] initWithCode:@"ca" andName:NSLocalizedString(@"ca", nil)];
    Language *en = [[Language alloc] initWithCode:@"en" andName:NSLocalizedString(@"en", nil)];
    Language *fr = [[Language alloc] initWithCode:@"fr" andName:NSLocalizedString(@"fr", nil)];
    Language *pt = [[Language alloc] initWithCode:@"pt" andName:NSLocalizedString(@"pt", nil)];
    Language *ca_valencia = [[Language alloc] initWithCode:@"ca_valencia" andName:NSLocalizedString(@"ca_valencia", nil)];

    LanguageDirection *esca = [[LanguageDirection alloc] initWithSourceLanguage:es andDestinationLanguage:ca];
    LanguageDirection *esca_valencia = [[LanguageDirection alloc] initWithSourceLanguage:es andDestinationLanguage:ca_valencia];
    [esca_valencia setVisible:NO];
    LanguageDirection *caes = [[LanguageDirection alloc] initWithSourceLanguage:ca andDestinationLanguage:es];
    LanguageDirection *enca = [[LanguageDirection alloc] initWithSourceLanguage:en andDestinationLanguage:ca];
    LanguageDirection *caen = [[LanguageDirection alloc] initWithSourceLanguage:ca andDestinationLanguage:en];
    LanguageDirection *frca = [[LanguageDirection alloc] initWithSourceLanguage:fr andDestinationLanguage:ca];
    LanguageDirection *cafr = [[LanguageDirection alloc] initWithSourceLanguage:ca andDestinationLanguage:fr];
    LanguageDirection *ptca = [[LanguageDirection alloc] initWithSourceLanguage:pt andDestinationLanguage:ca];
    LanguageDirection *capt = [[LanguageDirection alloc] initWithSourceLanguage:ca andDestinationLanguage:pt];

    [allCombinations addObject:esca];
    //[allCombinations addObject:esca_valencia];
    [allCombinations addObject:caes];
    [allCombinations addObject:enca];
    [allCombinations addObject:caen];
    [allCombinations addObject:frca];
    [allCombinations addObject:cafr];
    [allCombinations addObject:ptca];
    [allCombinations addObject:capt];

    return allCombinations;
}

+ (LanguageDirection *)loadValencianLanguageDirection
{
    Language *es = [[Language alloc] initWithCode:@"es" andName:NSLocalizedString(@"es", nil)];
    Language *ca_valencia = [[Language alloc] initWithCode:@"ca_valencia" andName:NSLocalizedString(@"ca_valencia", nil)];

    LanguageDirection *esca_valencia = [[LanguageDirection alloc] initWithSourceLanguage:es andDestinationLanguage:ca_valencia];
    return esca_valencia;
}
@end