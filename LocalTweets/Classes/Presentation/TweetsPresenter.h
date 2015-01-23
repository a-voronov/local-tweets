//
//  TweetsPresenter.h
//  LocalTweets
//
//  Created by Alexander Voronov on 23/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TweetsPresenter <NSObject>

- (void)reloadDataWithTweets:(NSArray *)tweets;

@end