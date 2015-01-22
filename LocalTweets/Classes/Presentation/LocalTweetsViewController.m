//
//  LocalTweetsViewController.m
//  LocalTweets
//
//  Created by Alexander Voronov on 18/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import "LocalTweetsViewController.h"
#import "ApplicationAssembly.h"
#import "TyphoonAutoInjection.h"
#import "TwitterAPIManager.h"

typedef enum PresentationType {
    PresentationTypeMap = 0,
    PresentationTypeTable
} PresentationType;


@interface LocalTweetsViewController ()

@property (nonatomic, strong) InjectedClass(ApplicationAssembly) assembly;
@property (nonatomic, strong) NSArray *presentationChildViewControllers;
@property (nonatomic, strong) UIViewController *currentPresentationViewController;

@end


@implementation LocalTweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loginWithTwitter];
    [self setupPresentationChildViewControllers];
    self.presentationTypeSegmentedControl.selectedSegmentIndex = PresentationTypeMap;
    [self switchToMapPresentation];
}

- (void)loginWithTwitter {
    [[self.assembly twitterApiManager] loginAsGuest:^(NSError *error) {
        NSDictionary *locationCoords = @{ @"latitude": @(50.254646), @"longitude": @(28.658665) };
        [[self.assembly twitterApiManager] getRecentNearestTweetsInLocation:locationCoords radius:@(10) count:@(20) completion:^(NSURLResponse *response, NSData *data, NSError *error) {
            NSLog(@"RESPONSE: %@", response);
            NSLog(@"DATA: %@", data);
            if (data) {
                NSError *jsonError;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                NSString *lastTweetId = json[@"statuses"][0][@"id"];
                [[[Twitter sharedInstance] APIClient] loadTweetWithID:lastTweetId completion:^(TWTRTweet *tweet, NSError *error) {
                    TWTRTweetView *tweetView = [[TWTRTweetView alloc] initWithTweet:tweet style:TWTRTweetViewStyleRegular];
                    [self.presentationContainerView addSubview:tweetView];
                }];
                
            } else {
                NSLog(@"Error: %@", error);
            }

        }];
    }];
}

- (void)setupPresentationChildViewControllers {
    UIViewController *mapPresentationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MapPresentationViewController"];
    UIViewController *tablePresentationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TablePresentationViewController"];
    self.presentationChildViewControllers = [[NSArray alloc] initWithObjects:mapPresentationViewController, tablePresentationViewController, nil];
    
}

- (IBAction)presentationTypeSegmentedControlDidChangeValue:(id)sender {
    UISegmentedControl *presentationTypeSegmentedControl = (UISegmentedControl *)sender;
    switch (presentationTypeSegmentedControl.selectedSegmentIndex) {
        case PresentationTypeMap:
            [self switchToMapPresentation];
            break;
        case PresentationTypeTable:
            [self switchToTablePresentation];
            break;
        default:
            break;
    }
}

- (void)switchToMapPresentation {
    [self switchToChildViewController:[self.presentationChildViewControllers objectAtIndex:PresentationTypeMap]];
}

- (void)switchToTablePresentation {
    [self switchToChildViewController:[self.presentationChildViewControllers objectAtIndex:PresentationTypeTable]];
}

- (void)switchToChildViewController:(UIViewController *)childViewController {
    if (childViewController == self.currentPresentationViewController) return;
    if (childViewController) {
        if (self.currentPresentationViewController) {
            [self hideChildViewController:self.currentPresentationViewController];
        }
        [self displayChildViewController:childViewController];
    }
}

- (void)displayChildViewController:(UIViewController *)childViewController {
    [self addChildViewController:childViewController];
    childViewController.view.frame = [self frameForPresentationChildController];
    [self.presentationContainerView addSubview:childViewController.view];
    [childViewController didMoveToParentViewController:self];
    self.currentPresentationViewController = childViewController;
}

- (void)hideChildViewController:(UIViewController *)childViewController {
    [childViewController willMoveToParentViewController:nil];
    [childViewController.view removeFromSuperview];
    [childViewController removeFromParentViewController];
}

- (CGRect)frameForPresentationChildController {
    return self.presentationContainerView.bounds;
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
