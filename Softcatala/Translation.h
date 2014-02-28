//
//  Translation.h
//  Softcatala
//
//  Created by Marcos Grau on 24/02/14.
//  Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LanguageDirection;

@interface Translation : NSObject

@property(nonatomic, copy) NSString *source;
@property(nonatomic, copy) NSString *translation;
@property(nonatomic, strong) LanguageDirection *languageDirection;
@property(nonatomic) BOOL favourite;

- (id)initWithSourceText:(NSString *)source translationText:(NSString *)translation languageDirection:(LanguageDirection *)languageDirection isFavorite:(BOOL)favourite;

@end
