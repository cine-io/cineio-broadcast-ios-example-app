//
//  CineBroadcasterView.m
//  Broadcaster
//
//  Created by Jeffrey Wescott on 6/6/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import "CineBroadcasterView.h"

@interface CineBroadcasterView ()
{
}

@end

@implementation CineBroadcasterView

@synthesize cameraView;
@synthesize statusView;
@synthesize status;
@synthesize controlsView;

- (void)awakeFromNib
{
    // set up UI
    cameraView = [[UIImageView alloc] initWithFrame:[self orientedBounds]];
    cameraView.backgroundColor = [UIColor blackColor];
    [cameraView setContentMode:UIViewContentModeCenter];
    [cameraView setContentMode:UIViewContentModeScaleAspectFit];
    
    UIColor *translucentBlack = [[UIColor alloc] initWithWhite:0.0 alpha:0.25];
    
    statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 40)];
    statusView.backgroundColor = translucentBlack;
    NSLog(@"statusView bounds: %.0fx%.0f @ %.0f,%.0f", statusView.bounds.size.width, statusView.bounds.size.height, statusView.bounds.origin.x, statusView.bounds.origin.y);
    status = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, statusView.bounds.size.width-20, 20)];
    status.backgroundColor = [UIColor clearColor];
    status.textColor = [UIColor whiteColor];
    status.font = [UIFont systemFontOfSize:12];
    status.textAlignment = NSTextAlignmentLeft;
    status.numberOfLines = 1;
    status.clipsToBounds = YES;
    status.text = @"Initializing";
    [statusView addSubview:status];
    
    controlsView = [[CineControlsView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-86, self.bounds.size.width, 86)];
    controlsView.backgroundColor = translucentBlack;

    [self addSubview:cameraView];
    [self addSubview:statusView];
    [self addSubview:controlsView];
}

- (CGRect)orientedBounds
{
    UIView *rootView = [[[UIApplication sharedApplication] keyWindow]
                        rootViewController].view;
    CGRect originalFrame = [[UIScreen mainScreen] bounds];
    CGRect adjustedFrame = [rootView convertRect:originalFrame fromView:nil];
    return adjustedFrame;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            NSLog(@"portrait");
            [UIView performWithoutAnimation:^{
                cameraView.frame = [self orientedBounds];
                controlsView.frame = CGRectMake(0, 568-86, 320, 86);
            }];
            statusView.frame = CGRectMake(0, 20, 320, 40);
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:
        {
            NSLog(@"landscape left");
            [UIView performWithoutAnimation:^{
                cameraView.frame = [self orientedBounds];
                controlsView.frame = CGRectMake(0, 0, 86, 320);
            }];
            statusView.frame = CGRectMake(86, 0, 568-86, 40);
        }
            break;
        case UIInterfaceOrientationLandscapeRight:
        {
            NSLog(@"landscape right");
            [UIView performWithoutAnimation:^{
                cameraView.frame = [self orientedBounds];
                controlsView.frame = CGRectMake(568-86, 0, 86, 320);
            }];
            statusView.frame = CGRectMake(0, 0, 568-86, 40);
        }
            break;
    }
}

@end
