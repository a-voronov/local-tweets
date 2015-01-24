//
//  MapPresentationViewController.m
//  LocalTweets
//
//  Created by Alexander Voronov on 19/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import "MapPresentationViewController.h"
#import "LocalTweetsDatasourceViewModel.h"
#import "Tweet.h"

@interface MapPresentationViewController ()

@end


@implementation MapPresentationViewController

@synthesize viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    
    [RACObserve(self.viewModel, tweets) subscribeNext:^(id x) {
        [self reloadData];
    }];
}

- (void)reloadData {
    Underscore.arrayEach(self.viewModel.tweets, ^(Tweet *tweet) {
        [self.mapView addAnnotation:[self pointForTweet:tweet]];
    });
}

- (MKPointAnnotation *)pointForTweet:(Tweet *)tweet {
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake(tweet.latitude, tweet.longtitude);
    point.title = tweet.author.name;
    point.subtitle = [@"@" stringByAppendingString:tweet.author.screenName];
    return point;
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    [self.mapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.1f, 0.1f)) animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
