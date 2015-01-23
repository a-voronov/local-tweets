//
//  MapPresentationViewController.h
//  LocalTweets
//
//  Created by Alexander Voronov on 19/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetsPresenter.h"

@interface MapPresentationViewController : UIViewController <MKMapViewDelegate, TweetsPresenter>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
