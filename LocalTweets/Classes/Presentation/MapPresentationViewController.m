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

static NSString * const TweetMapReuseIdentifier = @"TwitterPin";


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
    // TODO: Remove all pins first
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

//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
//    if ([annotation isKindOfClass:[MKUserLocation class]]) return nil;
//    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
//        MKAnnotationView *pinView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:TweetMapReuseIdentifier];
//        if (!pinView) {
//            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:TweetMapReuseIdentifier];
//            pinView.canShowCallout = YES;
////            pinView.image = [UIImage imageNamed:@"me.jpg"];
//            pinView.calloutOffset = CGPointMake(0, 42);
//            pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
////            pinView.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"me.jpg"]];
//        } else {
//            pinView.annotation = annotation;
//        }
//        return pinView;
//    }
//    return nil;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
