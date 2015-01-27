//
//  Settings.h
//  LocalTweets
//
//  Created by Alexander Voronov on 27/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppSettings.h"


@interface AppSettingsImpl : NSObject <AppSettings>

- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefaults;

@end
