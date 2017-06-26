//
//  HTTPRequest.h
//  CoreCategory
//
//  Created by LiuGuolong on 15/7/14.
//  Copyright (c) 2015年 LiuGuolong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HTTPRequestCompletionBlock)(NSData *data);
typedef void (^HTTPRequestErrorBlock)(NSError *error);

@interface HTTPRequestHelper : NSObject

+ (void)get:(NSString *)url isAsyn:(BOOL)isAsyn response:(HTTPRequestCompletionBlock)requestCompletion error:(HTTPRequestErrorBlock)requestError;
+ (void)get:(NSString *)url params:(NSDictionary *)params isAsyn:(BOOL)isAsyn response:(HTTPRequestCompletionBlock)requestCompletion error:(HTTPRequestErrorBlock)requestError;

+ (void)post:(NSString *)url params:(NSDictionary *)params isAsyn:(BOOL)isAsyn response:(HTTPRequestCompletionBlock)requestCompletion error:(HTTPRequestErrorBlock)requestError;

@end
