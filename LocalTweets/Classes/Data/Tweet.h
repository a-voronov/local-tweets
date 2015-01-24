//
//  Tweet.h
//  LocalTweets
//
//  Created by Alexander Voronov on 24/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import <TwitterKit/TwitterKit.h>

@interface Tweet : TWTRTweet

@property (nonatomic, assign, readonly) double latitude;
@property (nonatomic, assign, readonly) double longtitude;

@end
