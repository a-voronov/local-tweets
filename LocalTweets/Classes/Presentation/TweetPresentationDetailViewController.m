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
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Title.png"]];
    [self.tweetViewContainer addSubview:[[TWTRTweetView alloc] initWithTweet:self.tweet style:TWTRTweetViewStyleRegular]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
