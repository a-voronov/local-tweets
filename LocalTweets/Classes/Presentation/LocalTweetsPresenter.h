//
//  TweetsPresenter.h
//  LocalTweets
//
//  Created by Alexander Voronov on 23/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LocalTweetsDatasourceViewModel;


@protocol LocalTweetsPresenter <NSObject>

@property (nonatomic, strong) id<LocalTweetsDatasourceViewModel> viewModel;

@end