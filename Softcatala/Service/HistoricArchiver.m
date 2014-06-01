//
//  HistoricManager.m
//  Softcatala
//
//  Created by Marcos Grau on 31/05/14.
//  Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#import "HistoricArchiver.h"
#import "Translation.h"

@implementation HistoricArchiver

- (NSArray *)translations
{
    //Array filtrado de las lista de traducciones con los que no están marcados como deleted y ordenado por fecha.
    NSArray *translationsArray = [self sortArrayByCreatedAtTimeStamp:[self filteredTranslationsWithoutDeletedTranslations:[super translations]]];
    return translationsArray;
}

- (void)removeTranslation:(Translation *)translation
{
    if (translation.favourite == YES) {
        translation.deleted = YES;
        [super updateTranslation:translation];
    } else {
        [super removeTranslation:translation];
    }
}

- (void)removeAllTranslations
{
    NSMutableArray *itemsToRemove = [[NSMutableArray alloc] initWithArray:self.translations];
    
    for (Translation *itemToRemove in itemsToRemove) {
        [self removeTranslation:itemToRemove];
    }
}

- (NSArray *)sortArrayByCreatedAtTimeStamp:(NSArray *)filteredArray
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO];
    NSArray *sortedArray = [filteredArray sortedArrayUsingDescriptors:@[sortDescriptor]];
    return sortedArray;
}

- (NSArray *)filteredTranslationsWithoutDeletedTranslations:(NSArray *)translationsArray
{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        Translation *translation = evaluatedObject;
        if (translation.deleted == YES) {
            return NO;
        }
        return YES;
    }];
    
    NSArray *filteredArray = [translationsArray filteredArrayUsingPredicate:predicate];
    return filteredArray;
}
@end
