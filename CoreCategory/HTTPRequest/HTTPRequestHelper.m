//
//  HTTPRequest.m
//  CoreCategory
//
//  Created by LiuGuolong on 15/7/14.
//  Copyright (c) 2015年 LiuGuolong. All rights reserved.
//

#import "HTTPRequestHelper.h"

@implementation HTTPRequestHelper

+ (void)get:(NSString *)url isAsyn:(BOOL)isAsyn response:(HTTPRequestCompletionBlock)requestCompletion error:(HTTPRequestErrorBlock)requestError {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0f];
    [request setHTTPMethod:@"GET"];
    
    [HTTPRequestHelper sendRequest:request isAsyn:isAsyn response:requestCompletion error:requestError];
}

+ (void)get:(NSString *)url params:(NSDictionary *)params isAsyn:(BOOL)isAsyn response:(HTTPRequestCompletionBlock)requestCompletion error:(HTTPRequestErrorBlock)requestError {
    NSString *paramsStr = @"";
    if (params && params.count != 0) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        for (NSString *key in params.allKeys) {
            [array addObject:[NSString stringWithFormat:@"%@=%@", key, [params objectForKey:key]]];
        }
        paramsStr = [array componentsJoinedByString:@"&"];
    }
    url = [NSString stringWithFormat:@"%@?%@", url, paramsStr];
    
    [HTTPRequestHelper get:url isAsyn:isAsyn response:requestCompletion error:requestError];
}

+ (void)post:(NSString *)url params:(NSDictionary *)params isAsyn:(BOOL)isAsyn response:(HTTPRequestCompletionBlock)requestCompletion error:(HTTPRequestErrorBlock)requestError {
    NSString *paramsStr = @"";
    if (params && params.count != 0) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        for (NSString *key in params.allKeys) {
            [array addObject:[NSString stringWithFormat:@"%@=%@", key, [params objectForKey:key]]];
        }
        paramsStr = [array componentsJoinedByString:@"&"];
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0f];
    [request setHTTPMethod:@"POST"];
    if (paramsStr.length != 0) {
        NSData *data = [paramsStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        [request setHTTPBody:data];
    }
    
    [HTTPRequestHelper sendRequest:request isAsyn:isAsyn response:requestCompletion error:requestError];
}

+ (void)sendRequest:(NSURLRequest *)request isAsyn:(BOOL)isAsyn response:(HTTPRequestCompletionBlock)requestCompletion error:(HTTPRequestErrorBlock)requestError {
    if (isAsyn) {
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (connectionError) {
                    requestError(connectionError);
                } else {
                    requestCompletion(data);
                }
            });
        }];
    } else {
        NSError *errro = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&errro];
        if (errro) {
            requestError(errro);
        } else {
            requestCompletion(data);
        }
    }
}

@end
