//
//  LocalTweetsViewModelImpl.m
//  LocalTweets
//
//  Created by Alexander Voronov on 22/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import "LocalTweetsViewModelImpl.h"
#import "ApplicationAssembly.h"
#import "TwitterAPIManager.h"


@interface LocalTweetsViewModelImpl()

@property (nonatomic, strong) ApplicationAssembly *assembly;
@property (nonatomic, strong) RACSignal *guestLoginSignal;
@property (nonatomic, strong) RACSignal *frequentlyLoadRecentTweetsSignal;
@property (nonatomic, strong) NSArray *tweets;

@end


@implementation LocalTweetsViewModelImpl

- (instancetype)initWithAssembly:(ApplicationAssembly *)anAssembly {
    self = [super init];
    if (nil == self) return nil;
    self.assembly = anAssembly;

    @weakify(self)
    self.guestLoginSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[self.assembly twitterApiManager] loginAsGuest:^(NSError *error) {
            if (error) {
                [subscriber sendError:error];
            } else {
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            }
        }];
        return nil;
    }];
    
    RACSignal *loadRecentTweetsSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        NSDictionary *locationCoords = @{ @"latitude": @(50.254646), @"longitude": @(28.658665) };
        [[self.assembly twitterApiManager] getRecentNearestTweetsInLocation:locationCoords radius:@(10) count:@(30) completion:^(NSURLResponse *response, NSArray *recentTweets, NSError *error) {
            if (error) {
                [subscriber sendError:error];
            } else {
                self.tweets = recentTweets;
                [subscriber sendNext:recentTweets];
            }
        }];
        return nil;
    }];
    
    self.frequentlyLoadRecentTweetsSignal = [[[[[RACSignal interval:20 onScheduler:[RACScheduler mainThreadScheduler]]
        startWith:@[]]
        flattenMap:^RACStream *(id value) {
            return loadRecentTweetsSignal;
    }] publish] autoconnect];
    
    return self;
}

@end
