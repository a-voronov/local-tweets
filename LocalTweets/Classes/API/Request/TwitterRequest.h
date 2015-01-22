//
//  TwitterRequestProtocol.h
//  LocalTweets
//
//  Created by Alexander Voronov on 22/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

@protocol TwitterRequest <NSObject>

- (NSString *)url;
- (NSString *)apiMethod;
- (NSString *)requestMethod;
- (NSDictionary *)params;

@end