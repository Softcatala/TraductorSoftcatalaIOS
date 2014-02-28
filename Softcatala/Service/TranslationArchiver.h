//
// Created by Marcos Grau on 28/02/14.
// Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Translation;


@interface TranslationArchiver : NSObject

@property(nonatomic, readonly) NSInteger numberOfTranslations;

- (void)addTranslation:(Translation *)translation;

- (NSArray *)translations;

- (void)removeTranslation:(Translation *)translation;
@end