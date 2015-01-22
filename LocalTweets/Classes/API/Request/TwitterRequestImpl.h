//
//  TwitterRequest.h
//  LocalTweets
//
//  Created by Alexander Voronov on 22/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TwitterRequest.h"

@interface TwitterRequestImpl : NSObject <TwitterRequest>

- (instancetype)initWithApiURL:(NSString *)apiURL apiMethod:(NSString *)apiMethod requestMethod:(NSString *)requestMethod params:(NSDictionary *)params;

@end
