//
//  TwitterAPIManager.m
//  LocalTweets
//
//  Created by Alexander Voronov on 22/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import "TwitterAPIManagerImpl.h"
#import "ApplicationAssembly.h"
#import "TwitterAPIGateway.h"

@interface TwitterAPIManagerImpl()

@property (nonatomic, strong) ApplicationAssembly *applicationAssembly;

@end


@implementation TwitterAPIManagerImpl

- (instancetype)initWithAssembly:(ApplicationAssembly *)assembly {
    self = [super init];
    if (self) {
        self.applicationAssembly = assembly;
    }
    return self;
}

- (void)loginAsGuest:(TwitterAPIManagerGuestLogInCompletion)completion {
    [[Twitter sharedInstance] logInGuestWithCompletion:^(TWTRGuestSession *guestSession, NSError *error) {
        completion(error);
    }];
}

- (void)getRecentNearestTweetsInLocation:(NSDictionary *)coords radius:(NSNumber *)radius count:(NSNumber *)count completion:(TwitterAPIRequestCompletion)completion {
    id<TwitterAPIGateway> gateway = [self.applicationAssembly recentNearestTweetsGatewayWithLocationCoords:coords radiusKM:radius count:count];
    [gateway executeRequestWithCompletion:completion];
}

@end
