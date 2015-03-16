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
@property (assign, nonatomic) NSTimeInterval createdAt;
@property(nonatomic, assign) BOOL deleted;

- (id)initWithSourceText:(NSString *)source translationText:(NSString *)translation languageDirection:(LanguageDirection *)languageDirection isFavorite:(BOOL)favourite;

- (void)reverse;
@end
