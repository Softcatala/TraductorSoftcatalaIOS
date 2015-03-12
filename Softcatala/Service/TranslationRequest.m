//
// Created by marcos on 01/03/14.
// Copyright (c) 2014 Marcos Grau. All rights reserved.
//

#import "TranslationRequest.h"


@implementation TranslationRequest

- (void)postRequestWithText:(NSString *)textToTranslate andTextDirection:(NSString *)translationDirection success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure {
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    
    NSMutableString *urlString = [[NSMutableString alloc] init];
    [urlString appendString:kUrlString];
    [urlString appendString:@"?langpair="];
    [urlString appendString:[translationDirection stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [urlString appendString:@"&q="];
    [urlString appendString:[textToTranslate stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [urlString appendString:@"&markUnknown=yes"];
    [urlString appendString:@"&key="];
    [urlString appendString:kApiKey];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];

    NSURLSessionDataTask *postDataTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)  {
        if (error != nil) {
            NSLog(@"Request error: %@", error.description);
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
                    translatedText = [translatedText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
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