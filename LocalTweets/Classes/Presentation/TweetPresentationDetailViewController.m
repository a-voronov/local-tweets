//
//  TweetPresentationDetailViewController.m
//  LocalTweets
//
//  Created by Alexander Voronov on 26/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import "TweetPresentationDetailViewController.h"

@interface TweetPresentationDetailViewController ()

@end

@implementation TweetPresentationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitleViewImage];
    TWTRTweetView *tweetView = [self createTweetView];
    [self adjustScrollViewContentSizeForTweetView:tweetView];
    [self.tweetViewContainer addSubview:tweetView];
}

- (void)setNavigationTitleViewImage {
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Title.png"]];
}

- (TWTRTweetView *)createTweetView {
    TWTRTweetView *tweetView = [[TWTRTweetView alloc] initWithTweet:self.tweet style:TWTRTweetViewStyleRegular];
    tweetView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(tweetView.bounds));
    return tweetView;
}

- (void)adjustScrollViewContentSizeForTweetView:(TWTRTweetView *)tweetView {
    [self.tweetViewContainer setContentSize:CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetHeight(tweetView.bounds))];
}

@end
