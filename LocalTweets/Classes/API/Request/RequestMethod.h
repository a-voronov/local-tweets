//
//  RequestMethod.h
//  LocalTweets
//
//  Created by Alexander Voronov on 22/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestMethod : NSObject

+ (NSString *)GET;
+ (NSString *)POST;
+ (NSString *)PUT;
+ (NSString *)DELETE;

@end
