//
//  RecentNearestTweetsGateway.m
//  LocalTweets
//
//  Created by Alexander Voronov on 22/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import "RecentNearestTweetsGateway.h"
#import "ApplicationAssembly.h"
#import "RequestMethod.h"
#import "Tweet.h"

@interface RecentNearestTweetsGateway()

@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, assign) NSInteger radius;
@property (nonatomic, assign) NSInteger tweetsCount;

@end


@implementation RecentNearestTweetsGateway

- (instancetype)initWithLocationCoords:(NSDictionary *)coords radiusKM:(NSNumber *)radiusKM count:(NSNumber *)count assembly:(ApplicationAssembly *)assembly {
    self = [super initWithAssembly:assembly];
    if (self) {
        self.latitude = ((NSNumber *)coords[@"latitude"]).floatValue;
        self.longitude = ((NSNumber *)coords[@"longitude"]).floatValue;
        self.radius = radiusKM.integerValue;
        self.tweetsCount = count.integerValue;
    }
    return self;
}

- (id<TwitterRequest>)request {
    return [self.assembly twitterRequestWithApiMethod:@"search/tweets.json" requestMethod:RequestMethod.GET params:[self params]];
}

- (NSDictionary *)params {
    NSString *geocode = [NSString stringWithFormat:@"%f,%f,%dkm", self.latitude, self.longitude, self.radius];
    NSString *count = [NSString stringWithFormat:@"%d", self.tweetsCount];
    return @{ @"geocode": geocode, @"result_type": @"recent", @"count": count };
}

- (id)parseResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *)connectionError {
    NSError *jsonError;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
    if (jsonError) {
        return @[];
    } else {
        return [Tweet tweetsWithJSONArray:json[@"statuses"]];
    }
}

@end
