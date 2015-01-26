//
//  MapPresentationViewController.m
//  LocalTweets
//
//  Created by Alexander Voronov on 19/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import "MapPresentationViewController.h"
#import "MKAnnotationView+AFNetworking.h"
#import "LocalTweetsDatasourceViewModel.h"
#import "TweetAnnotation.h"
#import "TweetAnnotationView.h"
#import "Tweet.h"


@implementation MapPresentationViewController

@synthesize viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;

    MKCircle *circle = [MKCircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(50.254646, 28.658665) radius:10000];
    [self.mapView addOverlay:circle];
    
    
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

- (TweetAnnotation *)pointForTweet:(Tweet *)tweet {
    TweetAnnotation *annotation = [[TweetAnnotation alloc] initWithTweet:tweet];
    return annotation;
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    [self.mapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.1f, 0.1f)) animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(TweetAnnotation<MKAnnotation> *)annotation {
    if ([annotation isKindOfClass:MKUserLocation.class]) return nil;
    if ([annotation isKindOfClass:TweetAnnotation.class]) {
        TweetAnnotationView *pinView = (TweetAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotation.tweet.tweetID];
        if (!pinView) {
            pinView = [[TweetAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotation.tweet.tweetID];
            pinView.canShowCallout = YES;
            pinView.calloutOffset = CGPointMake(0, -2);
            [pinView setImageWithURL:[NSURL URLWithString:annotation.tweet.author.profileImageURL]
                    placeholderImage:[UIImage imageNamed:@"AvatarPlaceholder.png"]];
            pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:MKCircle.class]) {
        MKCircleRenderer *circleRenderer = [[MKCircleRenderer alloc] initWithOverlay:overlay];
        circleRenderer.fillColor = [UIColor colorWithRed:0.35f green:0.55f blue:0.83f alpha:0.5f];
        circleRenderer.alpha = 0.15;
        circleRenderer.lineWidth = 2.0;
        circleRenderer.strokeColor = [UIColor colorWithRed:0.2f green:0.4f blue:0.66f alpha:1.0f];
        return circleRenderer;
    }
    return nil;
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