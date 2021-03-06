//
// Created by marcos on 01/03/14.
// Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LanguageDirection;

@interface TranslationDirectionLoader : NSObject
- (NSArray *)loadAllCombinations;
+ (LanguageDirection *)loadValencianLanguageDirection;

@end