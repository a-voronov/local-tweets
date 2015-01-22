//
//  TwitterAPIGateway.h
//  LocalTweets
//
//  Created by Alexander Voronov on 22/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TwitterAPIGateway.h"

@class ApplicationAssembly;


@interface TwitterAPIGatewayImpl : NSObject <TwitterAPIGateway>

@property (readonly, nonatomic, strong) ApplicationAssembly *assembly;

- (instancetype)initWithAssembly:(ApplicationAssembly *)assembly;

@end
