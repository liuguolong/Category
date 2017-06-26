//
//  NetworkHelper.h
//  CoreCategory
//
//  Created by LiuGuolong on 15/7/14.
//  Copyright (c) 2015年 LiuGuolong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ISCONNECTED [NetworkHelper isConnected]

@interface NetworkHelper : NSObject

+ (BOOL)isConnected;

@end
