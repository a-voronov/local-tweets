//
//  LocalTweetsViewController.m
//  LocalTweets
//
//  Created by Alexander Voronov on 18/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import "LocalTweetsViewController.h"
#import <TwitterKit/TwitterKit.h>

@interface LocalTweetsViewController ()

@end

@implementation LocalTweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[Twitter sharedInstance] logInGuestWithCompletion:^(TWTRGuestSession *guestSession, NSError *error) {
        [[[Twitter sharedInstance] APIClient] loadTweetWithID:@"20" completion:^(TWTRTweet *tweet, NSError *error) {
            TWTRTweetView *tweetView = [[TWTRTweetView alloc] initWithTweet:tweet style:TWTRTweetViewStyleRegular];
            [self.view addSubview:tweetView];
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
