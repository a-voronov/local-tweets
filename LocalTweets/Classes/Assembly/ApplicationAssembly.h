//
//  ApplicationAssembly.h
//  LocalTweets
//
//  Created by Alexander Voronov on 22/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import "TyphoonAssembly.h"

@protocol TwitterAPIManager;
@protocol TwitterRequest;
@protocol TwitterAPIGateway;
@protocol LocalTweetsViewModel;


@interface ApplicationAssembly : TyphoonAssembly

- (id<TwitterAPIManager>)twitterApiManager;
- (id<TwitterRequest>)twitterRequestWithApiMethod:(NSString *)apiMethod requestMethod:(NSString *)requestMethod params:(NSDictionary *)params;
- (id<TwitterAPIGateway>)recentNearestTweetsGatewayWithLocationCoords:(NSDictionary *)coords radiusKM:(NSNumber *)radiusKM count:(NSNumber *)count;
- (id<LocalTweetsViewModel>)localTweetsViewModel;

@end
