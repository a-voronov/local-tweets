//
//  TwitterAPIManagerProtocol.h
//  LocalTweets
//
//  Created by Alexander Voronov on 22/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TwitterAPIManagerGuestLogInCompletion)(NSError *error);
typedef void (^TwitterAPIRequestCompletion)(NSURLResponse *response, id data, NSError *error);


@protocol TwitterAPIManager <NSObject>

- (void)loginAsGuest:(TwitterAPIManagerGuestLogInCompletion)completion;
- (void)getRecentNearestTweetsInLocation:(NSDictionary *)coords radius:(NSNumber *)radius count:(NSNumber *)count completion:(TwitterAPIRequestCompletion)completion;

@end