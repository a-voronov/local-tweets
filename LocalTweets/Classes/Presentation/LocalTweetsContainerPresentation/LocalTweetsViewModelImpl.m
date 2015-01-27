//
//  LocalTweetsViewModelImpl.m
//  LocalTweets
//
//  Created by Alexander Voronov on 22/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import "LocalTweetsViewModelImpl.h"
#import "TyphoonAutoInjection.h"
#import "ApplicationAssembly.h"
#import "TwitterAPIManager.h"
#import "AppSettings.h"

@interface LocalTweetsViewModelImpl()

@property (nonatomic, strong) ApplicationAssembly *assembly;
@property (nonatomic, strong) RACSignal *guestLoginSignal;
@property (nonatomic, strong) RACSignal *frequentlyLoadRecentTweetsSignal;
@property (nonatomic, strong) RACSignal *locationSignal;
@property (nonatomic, strong) RACSubject *locationSignalSubscriber;
@property (nonatomic, strong) NSArray *tweets;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, assign) CLAuthorizationStatus locationAuthStatus;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end


@implementation LocalTweetsViewModelImpl

- (instancetype)initWithAssembly:(ApplicationAssembly *)anAssembly {
    self = [super init];
    if (nil == self) return nil;
    self.assembly = anAssembly;
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 500;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;

    @weakify(self)
    self.guestLoginSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[self.assembly twitterApiManager] loginAsGuest:^(NSError *error) {
            if (error) {
                [subscriber sendError:error];
            } else {
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            }
        }];
        return nil;
    }];
    
    RACSignal *loadRecentTweetsSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        NSDictionary *locationCoords = @{ @"latitude": @(self.location.coordinate.latitude), @"longitude": @(self.location.coordinate.longitude) };
        [[self.assembly twitterApiManager] getRecentNearestTweetsInLocation:locationCoords
                                                                     radius:[[self.assembly appSettings] searchRadiusKM]
                                                                      count:[[self.assembly appSettings] numberOfTweets]
                                                                 completion:^(NSURLResponse *response, NSArray *recentTweets, NSError *error)
        {
            if (error) {
                [subscriber sendNext:error];
            } else {
                self.tweets = recentTweets;
                [subscriber sendNext:recentTweets];
            }
            [subscriber sendCompleted];
        }];
        return nil;
    }];
    
    self.frequentlyLoadRecentTweetsSignal = [[[[[RACSignal interval:[[self.assembly appSettings] pollFrequencySec].integerValue onScheduler:[RACScheduler mainThreadScheduler]]
        startWith:@[]]
        flattenMap:^RACStream *(id value) {
            return loadRecentTweetsSignal;
        }]
        publish]
        autoconnect];

    self.locationSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        self.locationSignalSubscriber = subscriber;
        CLAuthorizationStatus currentStatus = [CLLocationManager authorizationStatus];
        if (![self isStatusSuccessful:currentStatus]) {
            [self handleErrorStatuses:currentStatus];
        }
        if ([[self.assembly appSettings] currentIOSVersion].floatValue >= 8.0) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        return nil;
    }];

    return self;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self.locationSignalSubscriber sendError:error];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.location = (CLLocation *)locations[0];
    [self.locationSignalSubscriber sendNext:self.location];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if([self isStatusSuccessful:status]) {
        [self.locationManager startUpdatingLocation];
    } else {
        [self handleErrorStatuses:status];
    }
    self.locationAuthStatus = status;
}

- (BOOL)isStatusSuccessful:(CLAuthorizationStatus)status {
    return status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways;
}

- (void)handleErrorStatuses:(CLAuthorizationStatus)status {
    if(status == kCLAuthorizationStatusNotDetermined) {
        [self.locationSignalSubscriber sendError:[self errorWithCode:kCLAuthorizationStatusNotDetermined message:@"User Location Undetermined"]];
    } else if(status == kCLAuthorizationStatusRestricted) {
        [self.locationSignalSubscriber sendError:[self errorWithCode:kCLAuthorizationStatusRestricted message:@"User Location Restricted"]];
    } else if(status == kCLAuthorizationStatusDenied) {
        [self.locationSignalSubscriber sendError:[self errorWithCode:kCLAuthorizationStatusDenied message:@"User Location Denied"]];
    }
}

#pragma mark -

- (NSError *)errorWithCode:(NSInteger)code message:(NSString *)message {
    return [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:code userInfo:@{NSLocalizedDescriptionKey: message}];
}

@end
