//
//  TweetAnnotation.m
//  LocalTweets
//
//  Created by Alexander Voronov on 25/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import "TweetAnnotation.h"
#import "Tweet.h"
#import "NSDate+HumanizedTime.h"

@interface TweetAnnotation()

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, strong) Tweet *tweet;

@end


@implementation TweetAnnotation

- (instancetype)initWithTweet:(Tweet *)aTweet {
    self = [super init];
    if (self) {
        self.tweet = aTweet;
        self.coordinate = CLLocationCoordinate2DMake(self.tweet.latitude, self.tweet.longtitude);
        NSString *timeAgo = [[NSDate dateWithTimeInterval:0 sinceDate:self.tweet.createdAt] stringWithHumanizedTimeDifference:NSDateHumanizedSuffixNone withFullString:NO];
        self.title = [self.tweet.author.formattedScreenName stringByAppendingFormat:@": %@", timeAgo];
        self.subtitle = self.tweet.text;
    }
    return self;
}

@end
