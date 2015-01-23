//
//  LocalTweetsViewModelImpl.h
//  LocalTweets
//
//  Created by Alexander Voronov on 22/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalTweetsViewModel.h"

@class ApplicationAssembly;


@interface LocalTweetsViewModelImpl : NSObject <LocalTweetsViewModel>

- (instancetype)initWithAssembly:(ApplicationAssembly *)assembly;

@end
