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
#import "LocalTweetsPresenter.h"
#import "YRDropdownView.h"
#import "TweetPresentationDetailViewController.h"
typedef enum PresentationType {
    PresentationTypeMap = 0,
    PresentationTypeTable
} PresentationType;


@interface LocalTweetsViewController ()

@property (nonatomic, strong) InjectedClass(ApplicationAssembly) assembly;
@property (nonatomic, strong) InjectedProtocol(LocalTweetsViewModel) viewModel;
@property (nonatomic, strong) NSArray *presentationChildViewControllers;
@property (nonatomic, strong) UIViewController<LocalTweetsPresenter> *currentPresentationViewController;

@end


@implementation LocalTweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startLoadingData];
    [self setupPresentationChildViewControllers];
    [self setNavigationTitleViewImage];
    [self setMapPresentationAsDefault];
}

- (void)startLoadingData {
    [self.viewModel.guestLoginSignal subscribeError:^(NSError *error) {
        [self showErrorWithMessage:error.localizedDescription];
    } completed:^{
        [self.viewModel.locationSignal subscribeError:^(NSError *error) {
            [self showErrorWithMessage:error.localizedDescription];
        }];
        [self.viewModel.frequentlyLoadRecentTweetsSignal subscribeNext:^(id x) {
            if ([x isKindOfClass:NSError.class]) {
                [self showErrorWithMessage:((NSError *)x).localizedDescription];
            }
        }];
    }];
}

- (void)showErrorWithMessage:(NSString *)message {
    [YRDropdownView showDropdownInView:self.presentationContainerView title:message detail:nil image:nil animated:YES hideAfter:3.0f];
}

- (void)setupPresentationChildViewControllers {
    UIViewController<LocalTweetsPresenter> *mapPresentationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MapPresentationViewController"];
    UIViewController<LocalTweetsPresenter> *tablePresentationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TablePresentationViewController"];
    mapPresentationViewController.viewModel = self.viewModel;
    tablePresentationViewController.viewModel = self.viewModel;
    self.presentationChildViewControllers = [[NSArray alloc] initWithObjects:mapPresentationViewController, tablePresentationViewController, nil];
}

- (void)setNavigationTitleViewImage {
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Title.png"]];
}

- (void)setMapPresentationAsDefault {
    self.presentationTypeSegmentedControl.selectedSegmentIndex = PresentationTypeMap;
    [self switchToPresentationOfType:PresentationTypeMap];
}

#pragma mark - IBAction

- (IBAction)presentationTypeSegmentedControlDidChangeValue:(id)sender {
    UISegmentedControl *presentationTypeSegmentedControl = (UISegmentedControl *)sender;
    [self switchToPresentationOfType:(PresentationType)presentationTypeSegmentedControl.selectedSegmentIndex];
}

- (void)switchToPresentationOfType:(PresentationType)presentationType {
    [self switchToChildViewController:[self.presentationChildViewControllers objectAtIndex:presentationType]];
}

- (void)switchToChildViewController:(UIViewController<LocalTweetsPresenter> *)childViewController {
    if (childViewController == self.currentPresentationViewController) return;
    if (childViewController) {
        if (self.currentPresentationViewController) {
            [self hideChildViewController:self.currentPresentationViewController];
        }
        [self displayChildViewController:childViewController];
    }
}

- (void)displayChildViewController:(UIViewController<LocalTweetsPresenter> *)childViewController {
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(Tweet *)sender {
    ((TweetPresentationDetailViewController *)[segue destinationViewController]).tweet = sender;
}

@end
