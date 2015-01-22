//
//  TwitterRequest.m
//  LocalTweets
//
//  Created by Alexander Voronov on 22/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import "TwitterRequestImpl.h"

@interface TwitterRequestImpl()

@property (nonatomic, strong) NSString *twitterApiURL;
@property (nonatomic, strong) NSString *twitterApiMethod;
@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSDictionary *requestParams;

@end


@implementation TwitterRequestImpl

- (instancetype)initWithApiURL:(NSString *)apiURL apiMethod:(NSString *)apiMethod requestMethod:(NSString *)requestMethod params:(NSDictionary *)params {
    self = [super init];
    if (self) {
        self.twitterApiURL = apiURL;
        self.twitterApiMethod = apiMethod;
        self.method = requestMethod;
        self.requestParams = params;
    }
    return self;
}

- (NSString *)url {
    return [self.twitterApiURL stringByAppendingPathComponent:[self apiMethod]];
}

- (NSString *)apiMethod {
    return self.twitterApiMethod;
}

- (NSString *)requestMethod {
    return self.method;
}

- (NSDictionary *)params {
    return self.requestParams;
}

@end
