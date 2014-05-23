//
// Created by Marcos Grau on 28/02/14.
// Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Translation;


@interface TranslationArchiver : NSObject

@property(nonatomic, readonly) NSInteger numberOfTranslations;

- (NSArray *)translations;

- (void)addTranslation:(Translation *)translation;
- (void)removeTranslation:(Translation *)translation;
- (void)updateTranslation:(Translation *)translation;
- (void)removeAllTranslations;

@end