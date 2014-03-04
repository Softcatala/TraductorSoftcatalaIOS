//
// Created by marcos on 01/03/14.
// Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TranslationRequest : NSObject <NSURLSessionDelegate>

- (void)postRequestWithText:(NSString *)string andTextDirection:(NSString *)direction success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure;
@end