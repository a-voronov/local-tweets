//
//  Settings.h
//  LocalTweets
//
//  Created by Alexander Voronov on 27/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AppSettings <NSObject>

@property (nonatomic, strong, readonly) NSUserDefaults *userDefaults;

- (NSNumber *)searchRadiusKM;
- (NSNumber *)numberOfTweets;
- (NSNumber *)pollFrequencySec;
- (NSNumber *)currentIOSVersion;

@end