//
//  FavouriteArchiver.m
//  Softcatala
//
//  Created by Marcos Grau on 01/06/14.
//  Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#import "FavouriteArchiver.h"
#import "TRanslation.h"

@implementation FavouriteArchiver

- (NSArray *)translations
{
    NSArray *translationsArray = [self sortArrayByCreatedAtTimeStamp:[self filteredFavouriteTranslations:[super translations]]];
    return translationsArray;
}


- (NSArray *)filteredFavouriteTranslations:(NSArray *)translationsArray
{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        Translation *translation = evaluatedObject;
        return translation.favourite;
    }];
    
    NSArray *filteredArray = [translationsArray filteredArrayUsingPredicate:predicate];
    return filteredArray;
}

- (NSArray *)sortArrayByCreatedAtTimeStamp:(NSArray *)filteredArray
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO];
    NSArray *sortedArray = [filteredArray sortedArrayUsingDescriptors:@[sortDescriptor]];
    return sortedArray;
}

- (void)updateTranslation:(Translation *)translation
{
    if (translation.deleted == YES && translation.favourite == NO) {
        [super removeTranslation:translation];
    } else {
        [super updateTranslation:translation];
    }
}

@end
