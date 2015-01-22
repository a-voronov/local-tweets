//
//  RequestMethod.m
//  LocalTweets
//
//  Created by Alexander Voronov on 22/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import "RequestMethod.h"

@implementation RequestMethod

+ (NSString *)GET {
    return @"GET";
}

+ (NSString *)POST {
    return @"POST";
}

+ (NSString *)PUT {
    return @"PUT";
}

+ (NSString *)DELETE {
    return @"DELETE";
}

@end
