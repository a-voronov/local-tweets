//
//  MapPresentationViewController.m
//  LocalTweets
//
//  Created by Alexander Voronov on 19/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import "MapPresentationViewController.h"
#import "MKAnnotationView+AFNetworking.h"
#import "TyphoonAutoInjection.h"
#import "LocalTweetsDatasourceViewModel.h"
#import "TweetAnnotation.h"
#import "TweetAnnotationView.h"
#import "Tweet.h"
#import "AppSettings.h"


@interface MapPresentationViewController()

@property (nonatomic, strong) MKCircle *circle;
@property (nonatomic, strong) InjectedProtocol(AppSettings) settings;

@end


@implementation MapPresentationViewController

@synthesize viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    
    [RACObserve(self.viewModel, locationAuthStatus) subscribeNext:^(id x) {
        self.mapView.showsUserLocation = YES;
    } error:^(NSError *error) {
        self.mapView.showsUserLocation = NO;
    }];
    
    @weakify(self)
    [[RACSignal combineLatest:@[RACObserve(self.viewModel, tweets), [RACObserve(self.viewModel, location) distinctUntilChanged]] reduce:^id (id x, CLLocation *location) {
        return location;
    }] subscribeNext:^(CLLocation *location) {
        @strongify(self)
        [self.mapView removeOverlay:self.circle];
        self.circle = [MKCircle circleWithCenterCoordinate:location.coordinate radius:[self.settings searchRadiusKM].integerValue * 1000];
        [self.mapView addOverlay:self.circle];
        [self reloadData];
    }];
}

- (void)reloadData {
    [self.mapView removeAnnotations:self.mapView.annotations];
    Underscore.arrayEach(self.viewModel.tweets, ^(Tweet *tweet) {
        [self.mapView addAnnotation:[self pointForTweet:tweet]];
    });
}

- (TweetAnnotation *)pointForTweet:(Tweet *)tweet {
    TweetAnnotation *annotation = [[TweetAnnotation alloc] initWithTweet:tweet];
    return annotation;
}

#pragma mark - MKMapViewDelegate

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

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    TweetAnnotation *annotation = view.annotation;
    [self.parentViewController performSegueWithIdentifier:@"showMapTweetDetailsSegue" sender:annotation.tweet];
}

@end
