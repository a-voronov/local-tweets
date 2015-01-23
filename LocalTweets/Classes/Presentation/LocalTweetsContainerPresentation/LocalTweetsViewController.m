//
//  LocalTweetsViewController.m
//  LocalTweets
//
//  Created by Alexander Voronov on 18/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import "LocalTweetsViewController.h"
#import "ApplicationAssembly.h"
#import "LocalTweetsViewModel.h"
#import "TyphoonAutoInjection.h"
#import "TwitterAPIManager.h"
#import "TweetsPresenter.h"

typedef enum PresentationType {
    PresentationTypeMap = 0,
    PresentationTypeTable
} PresentationType;


@interface LocalTweetsViewController ()

@property (nonatomic, strong) InjectedClass(ApplicationAssembly) assembly;
@property (nonatomic, strong) InjectedProtocol(LocalTweetsViewModel) viewModel;
@property (nonatomic, strong) NSArray *presentationChildViewControllers;
@property (nonatomic, strong) UIViewController<TweetsPresenter> *currentPresentationViewController;

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
    [self.viewModel.guestLoginSignal subscribeError:^(NSError *error) {
        NSLog(@"Error login as guest user: %@", error);
    } completed:^{
        [self.viewModel.frequentlyLoadRecentTweetsSignal subscribeNext:^(NSArray *tweets) {
            [self reloadCurrentPresentationViewControllerWithRecentTweets:tweets];
        } error:^(NSError *error) {
            NSLog(@"Error fetching recent tweets: %@", error);
        }];
    }];
}

- (void)reloadCurrentPresentationViewControllerWithRecentTweets:(NSArray *)tweets {
    [self.currentPresentationViewController reloadDataWithTweets:tweets];
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

- (void)switchToChildViewController:(UIViewController<TweetsPresenter> *)childViewController {
    if (childViewController == self.currentPresentationViewController) return;
    if (childViewController) {
        if (self.currentPresentationViewController) {
            [self hideChildViewController:self.currentPresentationViewController];
        }
        [self displayChildViewController:childViewController];
        [self reloadCurrentPresentationViewControllerWithRecentTweets:self.viewModel.recentTweets];
    }
}

- (void)displayChildViewController:(UIViewController<TweetsPresenter> *)childViewController {
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
