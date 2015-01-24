//
//  Tweet.m
//  LocalTweets
//
//  Created by Alexander Voronov on 24/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import "Tweet.h"

@interface Tweet()

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longtitude;

@end


@implementation Tweet

- (instancetype)initWithJSONDictionary:(NSDictionary *)dictionary {
    self = [super initWithJSONDictionary:dictionary];
    if (self) {
        NSDictionary *geo = dictionary[@"geo"];
        if (geo) {
            NSArray *coords = geo[@"coordinates"];
            if (coords.count >= 2) {
                self.latitude = ((NSString *)coords[0]).doubleValue;
                self.longtitude = ((NSString *)coords[1]).doubleValue;
            }
        }
    }
    return self;
}

+ (NSArray *)tweetsWithJSONArray:(NSArray *)array {
    return Underscore.arrayMap(array, ^Tweet *(NSDictionary *dict) {
        return [[Tweet alloc] initWithJSONDictionary:dict];
    });
}

@end
