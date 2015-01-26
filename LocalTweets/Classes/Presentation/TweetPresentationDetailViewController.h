//
//  TweetPresentationDetailViewController.h
//  LocalTweets
//
//  Created by Alexander Voronov on 26/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetPresentationDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *tweetViewContainer;

@property (nonatomic, strong) Tweet *tweet;

@end
