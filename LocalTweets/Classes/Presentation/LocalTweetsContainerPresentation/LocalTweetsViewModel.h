//
//  LocalTweetsViewModel.h
//  LocalTweets
//
//  Created by Alexander Voronov on 22/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalTweetsDatasourceViewModel.h"

typedef void (^LoadRecentNearestTweetsCompletion)(NSArray *tweets, NSError *error);


@protocol LocalTweetsViewModel <LocalTweetsDatasourceViewModel>

@property (nonatomic, strong, readonly) RACSignal *guestLoginSignal;
@property (nonatomic, strong, readonly) RACSignal *frequentlyLoadRecentTweetsSignal;
@property (nonatomic, strong, readonly) RACSignal *locationSignal;

//In Future can be setup in some settings
//@property (nonatomic, strong) NSNumber *searchRadius;
//@property (nonatomic, strong) NSNumber *tweetsMaxCount;

@end