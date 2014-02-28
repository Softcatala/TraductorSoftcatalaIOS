//
// Created by Marcos Grau on 28/02/14.
// Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#import "Language.h"


@implementation Language {

}
- (instancetype)initWithCode:(NSString *)code {
    self = [super init];
    if (self) {
        self.code = code;
    }

    return self;
}

+ (instancetype)languageWithCode:(NSString *)code {
    return [[self alloc] initWithCode:code];
}

@end