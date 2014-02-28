//
// Created by Marcos Grau on 28/02/14.
// Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Language : NSObject

@property(nonatomic, copy) NSString *code;

- (instancetype)initWithCode:(NSString *)code;

@end