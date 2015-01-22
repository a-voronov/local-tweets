//
//  RecentNearestTweetsGateway.h
//  LocalTweets
//
//  Created by Alexander Voronov on 22/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import "TwitterAPIGatewayImpl.h"

@interface RecentNearestTweetsGateway : TwitterAPIGatewayImpl

- (instancetype)initWithLocationCoords:(NSDictionary *)coords radiusKM:(NSNumber *)radiusKM count:(NSNumber *)count assembly:(ApplicationAssembly *)assembly;

@end
