//
//  TwitterAPIGatewayProtocol.h
//  LocalTweets
//
//  Created by Alexander Voronov on 22/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TwitterAPIRequestCompletion)(NSURLResponse *response, id data, NSError *error);


@protocol TwitterAPIGateway <NSObject>

- (void)executeRequestWithCompletion:(TwitterAPIRequestCompletion)completion;

@end
