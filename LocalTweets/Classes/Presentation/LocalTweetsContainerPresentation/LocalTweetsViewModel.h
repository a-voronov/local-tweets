//
//  LocalTweetsViewModel.h
//  LocalTweets
//
//  Created by Alexander Voronov on 22/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^LoadRecentNearestTweetsCompletion)(NSArray *tweets, NSError *error);


@protocol LocalTweetsViewModel <NSObject>

@property (nonatomic, strong, readonly) RACSignal *guestLoginSignal;
@property (nonatomic, strong, readonly) RACSignal *frequentlyLoadRecentTweetsSignal;
@property (nonatomic, strong, readonly) NSArray *recentTweets;

//@property (nonatomic, strong) NSString *searchRadius;
//@property (nonatomic, strong) NSNumber *tweetsMaxCount;

@end