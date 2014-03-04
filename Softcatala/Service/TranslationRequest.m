//
// Created by marcos on 01/03/14.
// Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#import "TranslationRequest.h"


@implementation TranslationRequest {
    NSString *urlString;
    NSString *apiKey;
}

- (id)init {
    self = [super init];

    if (self) {
        urlString  = @"http://www.softcatala.org/apertium/json/translate";
        apiKey = @"NWI0MjQwMzQzMDYxMzA2NDYzNjQ";
    }

    return self;
}

- (void)postRequestWithText:(NSString *)textToTranslate andTextDirection:(NSString *)translationDirection success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure {
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: @"langpair", translationDirection,
                                                                          @"q", textToTranslate,
                                                                          @"markUnknown", @"yes",
                                                                          @"key", apiKey,
                                                                          nil];
    NSError *errorMapping;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&errorMapping];

    if (errorMapping != nil) {
        failure(errorMapping);
        return;
    }

    [request setHTTPBody:postData];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];

    NSURLSessionDataTask *postDataTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)  {
        if (error != nil) {
            NSLog(@"Fallo en request: %@", error.description);
            failure(error);
        } else {
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSDictionary *responseData = jsonResponse[@"responseData"];
            if (responseData != nil) {
                NSString *translatedText = responseData[@"translatedText"];
                success(translatedText);
            } else {
                failure(nil);
            }
        }
    }];

    [postDataTask resume];


}
@end