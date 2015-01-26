//
//  TweetAnnotationView.m
//  LocalTweets
//
//  Created by Alexander Voronov on 26/1/15.
//  Copyright (c) 2015 Alexander Voronov. All rights reserved.
//

#import "TweetAnnotationView.h"

@implementation TweetAnnotationView

- (void)setImage:(UIImage *)image {
    [super setImage:[self imageWrappedInPinImage:image]];
}

- (UIImage *)imageWrappedInPinImage:(UIImage *)image {
    UIImage *pinImage = [UIImage imageNamed:@"Pin.png"];

    UIImage *wrappedImage = nil;

    CGSize newImageSize = CGSizeMake(64, 64);
    UIGraphicsBeginImageContextWithOptions(newImageSize, NO, 0.0);
    [image drawInRect:CGRectMake(13, 8, 38, 37)];
    [pinImage drawInRect:CGRectMake(0, 0, 64, 64)];

    wrappedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return wrappedImage;
}

@end
