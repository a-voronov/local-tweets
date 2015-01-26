//
//  TablePresentationViewController.h
//  LocalTweets
//
//  Created by Alexander Voronov on 19/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalTweetsPresenter.h"

@interface TablePresentationViewController : UITableViewController <TWTRTweetViewDelegate, LocalTweetsPresenter>

@end
