//
//  TwitterAPIGateway.m
//  LocalTweets
//
//  Created by Alexander Voronov on 22/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import "TwitterAPIGatewayImpl.h"
#import "TwitterRequest.h"
#import "ApplicationAssembly.h"
#import "RequestMethod.h"

@interface TwitterAPIGatewayImpl()

@property (nonatomic, strong) ApplicationAssembly *applicationAssembly;

- (NSURLRequest *)prepareNSURLRequest:(NSError **)error;

@end


@implementation TwitterAPIGatewayImpl

- (instancetype)initWithAssembly:(ApplicationAssembly *)assembly {
    self = [super init];
    if (self) {
        self.applicationAssembly = assembly;
    }
    return self;
}

- (ApplicationAssembly *)assembly {
    return self.applicationAssembly;
}

- (void)executeRequestWithCompletion:(TwitterAPIRequestCompletion)completion {
    NSError *error = nil;
    NSURLRequest *urlRequest = [self prepareNSURLRequest:&error];
    if (error) {
        completion(nil, nil, error);
    } else {
        [[[Twitter sharedInstance] APIClient] sendTwitterRequest:urlRequest completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            id parsedResponseData = [self parseResponse:response data:data error:connectionError];
            completion(response, parsedResponseData, connectionError);
        }];
    }
}

- (NSURLRequest *)prepareNSURLRequest:(NSError **)error {
    TWTRAPIClient *twitterApiClient = [[Twitter sharedInstance] APIClient];
    return [twitterApiClient URLRequestWithMethod:[[self request] requestMethod]
                                              URL:[[self request] url]
                                       parameters:[[self request] params]
                                            error:error];
}

- (id<TwitterRequest>)request {
    return nil;
}

- (id)parseResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *)connectionError {
    return data;
}

@end
