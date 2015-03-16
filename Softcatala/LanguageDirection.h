//
// Created by marcos on 24/02/14.
// Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Language;

@interface LanguageDirection : NSObject {

}

@property(nonatomic, strong) Language *destinationLanguage;
@property(nonatomic, strong) Language *sourceLanguage;
@property(nonatomic) BOOL visible;

- (id)initWithSourceLanguage:(Language *)sourceLanguage andDestinationLanguage:(Language *)destinationLanguage;

- (void)reverse;
@end