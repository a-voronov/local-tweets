//
//  LocalTweetsDatasourceViewModel.h
//  LocalTweets
//
//  Created by Alexander Voronov on 24/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LocalTweetsDatasourceViewModel <NSObject>

@property (nonatomic, strong, readonly) NSArray *tweets;

@end