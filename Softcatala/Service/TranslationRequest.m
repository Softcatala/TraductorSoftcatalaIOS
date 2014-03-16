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
    
    NSMutableString *postString = [[NSMutableString alloc] init];
    [postString appendString:@"langpair="];
    [postString appendString:translationDirection];
    [postString appendString:@"&q="];
    [postString appendString:textToTranslate];
    [postString appendString:@"&markUnknown=yes"];
    [postString appendString:@"&key="];
    [postString appendString:apiKey];
    
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    
    
    [request setHTTPBody:postData];
    [request setHTTPMethod:@"POST"];

    NSURLSessionDataTask *postDataTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)  {
        if (error != nil) {
            NSLog(@"Fallo en request: %@", error.description);
            failure(error);
        } else {
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSDictionary *responseData = jsonResponse[@"responseData"];
            if (responseData != nil) {
                if (jsonResponse[@"responseStatus"] != nil && [jsonResponse[@"responseStatus"] intValue] != 200)
                {
                    failure([self httpError:jsonResponse]);
                } else {
                    NSString *translatedText = responseData[@"translatedText"];
                    success(translatedText);
                }
            } else {
                failure([self httpError:jsonResponse]);
            }
        }
    }];

    [postDataTask resume];


}

- (NSError *)httpError:(NSDictionary *)response
{
    NSMutableDictionary *errorDetails = [[NSMutableDictionary alloc] init];
    [errorDetails setValue:NSLocalizedString(@"ResponseGeneralError", nil) forKey:NSLocalizedDescriptionKey];
    NSInteger errorCode = response != nil ? [response[@"responseStatus"] intValue] : 500;
    NSError *error = [[NSError alloc] initWithDomain:@"Softcatala" code:errorCode userInfo:errorDetails];
    return error;
}

@end