//
//  LocalTweetsViewController.h
//  LocalTweets
//
//  Created by Alexander Voronov on 18/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocalTweetsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *presentationTypeSegmentedControl;
@property (weak, nonatomic) IBOutlet UIView *presentationContainerView;

- (IBAction)presentationTypeSegmentedControlDidChangeValue:(id)sender;

@end
