//
//  TweetAnnotation.h
//  LocalTweets
//
//  Created by Alexander Voronov on 25/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Tweet;


@interface TweetAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic, strong, readonly) Tweet *tweet;

- (instancetype)initWithTweet:(Tweet *)tweet;

@end
