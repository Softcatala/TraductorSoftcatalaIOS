//
// Created by Marcos Grau on 28/02/14.
// Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Language : NSObject

@property(nonatomic, copy) NSString *code;
@property(nonatomic, copy) NSString *name;

- (instancetype)initWithCode:(NSString *)code andName:(NSString *)name;

@end