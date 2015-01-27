//
//  Settings.m
//  LocalTweets
//
//  Created by Alexander Voronov on 27/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import "AppSettingsImpl.h"

@interface AppSettingsImpl ()

@property (nonatomic, strong) NSUserDefaults *userDefaults;

@end


@implementation AppSettingsImpl

- (instancetype)initWithUserDefaults:(NSUserDefaults *)defaultUserDefaults {
    self = [super init];
    if (self) {
        self.userDefaults = defaultUserDefaults;
    }
    return self;
}

- (NSNumber *)searchRadiusKM {
    return [self valueForKey:@"search_radius_slider"];
}

- (NSNumber *)numberOfTweets {
    return [self valueForKey:@"number_of_tweets_slider"];
}

- (NSNumber *)pollFrequencySec {
    return [self valueForKey:@"poll_frequency_slider"];
}

- (NSNumber *)currentIOSVersion {
    return @([[UIDevice currentDevice] systemVersion].floatValue);
}

- (NSNumber *)valueForKey:(NSString *)key {
    NSNumber *value = [self.userDefaults valueForKey:key];
    if (nil == value) {
        [self setupSettingsBundle];
        return [self.userDefaults valueForKey:key];
    }
    return value;
}

- (void)setupSettingsBundle {
    NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
    NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];
    for (NSDictionary *prefSpecification in preferences) {
        NSString *key = [prefSpecification objectForKey:@"Key"];
        if(key) {
            [[NSUserDefaults standardUserDefaults] setValue:[prefSpecification valueForKey:@"DefaultValue"] forKey:key];
        }
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
