//
//  LocalTweetsViewModelImpl.m
//  LocalTweets
//
//  Created by Alexander Voronov on 22/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import "LocalTweetsViewModelImpl.h"
#import "ApplicationAssembly.h"


@interface LocalTweetsViewModelImpl()

@property (nonatomic, strong) ApplicationAssembly *assembly;

@end


@implementation LocalTweetsViewModelImpl

//@synthesize tweetsMaxCount, searchRadius, recentTweets;

- (instancetype)initWithAssembly:(ApplicationAssembly *)anAssembly {
    self = [super init];
    if (self) {
        self.assembly = anAssembly;
    }
    return self;
}

- (void)loginAsGuest:(TwitterAPIManagerGuestLogInCompletion)completion {
    [[self.assembly twitterApiManager] loginAsGuest:completion];
}

- (void)loadRecentNearestTweetsWithCompletion:(LoadRecentNearestTweetsCompletion)completion {
    NSDictionary *locationCoords = @{ @"latitude": @(50.254646), @"longitude": @(28.658665) };
    [[self.assembly twitterApiManager] getRecentNearestTweetsInLocation:locationCoords radius:@(10) count:@(30) completion:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (data) {
            NSError *jsonError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (jsonError) {
                completion(nil, jsonError);
            } else {
                NSArray *tweets = [TWTRTweet tweetsWithJSONArray:json[@"statuses"]];
                completion(tweets, nil);
            }
        } else {
            completion(nil, error);
        }
    }];
}

@end
