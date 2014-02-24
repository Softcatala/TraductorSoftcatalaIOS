//
//  HistoricalItem.h
//  Softcatala
//
//  Created by Marcos Grau on 24/02/14.
//  Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoricalItem : NSObject

- (id)initWithSourceText:(NSString *)source translationText:(NSString *)translation languageDirection:(NSString *)languageDirection isFavorite:(BOOL)favourite;

@end
