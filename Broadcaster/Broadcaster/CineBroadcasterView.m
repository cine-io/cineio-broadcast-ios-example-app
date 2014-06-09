//
//  CineBroadcasterView.m
//  Broadcaster
//
//  Created by Jeffrey Wescott on 6/6/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import "CineBroadcasterView.h"
#import <Masonry/Masonry.h>

@interface CineBroadcasterView ()
{
    MASConstraint *_controlsViewWidth, *_controlsViewHeight, *_controlsViewTop, *_controlsViewBottom, *_controlsViewLeft, *_controlsViewRight;
    MASConstraint *_statusContainerViewWidth, *_statusContainerViewHeight, *_statusContainerViewTop, *_statusContainerViewBottom, *_statusContainerViewLeft, *_statusContainerViewRight;
    MASConstraint *_statusViewWidth, *_statusViewHeight, *_statusViewTop, *_statusViewBottom, *_statusViewLeft, *_statusViewRight;
}

- (void)updateConstraints:(UIInterfaceOrientation)orientation;
- (void)updateConstraintsControlsView:(UIInterfaceOrientation)orientation;
- (void)updateConstraintsStatusContainerView:(UIInterfaceOrientation)orientation;
- (void)updateConstraintsStatusView:(UIInterfaceOrientation)orientation;

@end

@implementation CineBroadcasterView

@synthesize cameraView;

@synthesize statusContainerView;
@synthesize statusView;
@synthesize status;

@synthesize controlsView;
@synthesize recordButton;


-(void)awakeFromNib
{
    // set up UI
    recordButton.enabled = NO;
    [self.cameraView setContentMode:UIViewContentModeCenter];
    [self.cameraView setContentMode:UIViewContentModeScaleAspectFit];
    self.status.text = @"Initializing";

    // for debugging
    self.mas_key = @"broadcasterView";
    controlsView.mas_key = @"controlsView";
    statusContainerView.mas_key = @"statusContainerView";
    statusView.mas_key = @"statusView";
    recordButton.mas_key = @"recordButton";
}

- (void)updateConstraints
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    [self updateConstraints:orientation];
    [super updateConstraints];
    [self.layer removeAllAnimations];
    [self.controlsView.layer removeAllAnimations];
}

- (void)updateConstraints:(UIInterfaceOrientation)orientation
{
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
            NSLog(@"portrait");
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            NSLog(@"portrait upside down");
            break;
        case UIInterfaceOrientationLandscapeLeft:
            NSLog(@"landscape left");
            break;
        case UIInterfaceOrientationLandscapeRight:
            NSLog(@"landscape right");
            break;
    }
    
    [self updateConstraintsControlsView:orientation];
    [self updateConstraintsStatusContainerView:orientation];
    [self updateConstraintsStatusView:orientation];
}

- (void)updateConstraintsControlsView:(UIInterfaceOrientation)orientation
{
    [_controlsViewWidth uninstall];
    [_controlsViewHeight uninstall];
    [_controlsViewTop uninstall];
    [_controlsViewRight uninstall];
    [_controlsViewBottom uninstall];
    [_controlsViewLeft uninstall];

    int topOffset = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
        {
            [controlsView mas_makeConstraints:^(MASConstraintMaker *make) {
                _controlsViewWidth = make.width.equalTo(self.mas_width);
                _controlsViewHeight = make.height.equalTo(@86);
                _controlsViewRight = make.right.equalTo(self.mas_right).with.offset(0);
                _controlsViewBottom = make.bottom.equalTo(self.mas_bottom).with.offset(0);
                _controlsViewLeft = make.left.equalTo(self.mas_left).with.offset(0);
            }];
        }
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            [controlsView mas_makeConstraints:^(MASConstraintMaker *make) {
                _controlsViewWidth = make.width.equalTo(self.mas_width);
                _controlsViewHeight = make.height.equalTo(@86);
                _controlsViewTop = make.top.equalTo(self.mas_top).with.offset(0+topOffset);
                _controlsViewRight = make.right.equalTo(self.mas_right).with.offset(0);
                _controlsViewLeft = make.left.equalTo(self.mas_left).with.offset(0);
            }];
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:
        {
            [controlsView mas_makeConstraints:^(MASConstraintMaker *make) {
                _controlsViewWidth = make.width.equalTo(@86);
                _controlsViewHeight = make.height.equalTo(self.mas_height);
                _controlsViewTop = make.top.equalTo(self.mas_top).with.offset(0);
                _controlsViewBottom = make.bottom.equalTo(self.mas_bottom).with.offset(0);
                _controlsViewLeft = make.left.equalTo(self.mas_left).with.offset(0);
            }];
        }
            break;
        case UIInterfaceOrientationLandscapeRight:
        {
            [controlsView mas_makeConstraints:^(MASConstraintMaker *make) {
                _controlsViewWidth = make.width.equalTo(@86);
                _controlsViewHeight = make.height.equalTo(self.mas_height);
                _controlsViewTop = make.top.equalTo(self.mas_top).with.offset(0);
                _controlsViewRight = make.right.equalTo(self.mas_right).with.offset(0);
                _controlsViewBottom = make.bottom.equalTo(self.mas_bottom).with.offset(0);
            }];
        }
            break;
    }
}

- (void)updateConstraintsStatusContainerView:(UIInterfaceOrientation)orientation
{
    [_statusContainerViewWidth uninstall];
    [_statusContainerViewHeight uninstall];
    [_statusContainerViewTop uninstall];
    [_statusContainerViewRight uninstall];
    [_statusContainerViewBottom uninstall];
    [_statusContainerViewLeft uninstall];

    int topOffset = [UIApplication sharedApplication].statusBarFrame.size.height;

    switch (orientation) {
        case UIInterfaceOrientationPortrait:
        {
            [statusContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
                _statusContainerViewWidth = make.width.equalTo(self.mas_width);
                _statusContainerViewTop = make.top.equalTo(self.mas_top).with.offset(0+topOffset);
                _statusContainerViewRight = make.right.equalTo(self.mas_right).with.offset(0);
                _statusContainerViewBottom = make.bottom.equalTo(self.mas_bottom).with.offset(86);
                _statusContainerViewLeft = make.left.equalTo(self.mas_left).with.offset(0);
            }];
        }
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            [statusContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
                _statusContainerViewWidth = make.width.equalTo(self.mas_width);
                _statusContainerViewTop = make.top.equalTo(self.mas_top).with.offset(86);
                _statusContainerViewRight = make.right.equalTo(self.mas_right).with.offset(0);
                _statusContainerViewBottom = make.bottom.equalTo(self.mas_bottom).with.offset(0);
                _statusContainerViewLeft = make.left.equalTo(self.mas_left).with.offset(0);
            }];
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:
        {
            [statusContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
                _statusContainerViewHeight = make.height.equalTo(self.mas_height);
                _statusContainerViewTop = make.top.equalTo(self.mas_top).with.offset(0);
                _statusContainerViewRight = make.right.equalTo(self.mas_right).with.offset(0);
                _statusContainerViewBottom = make.bottom.equalTo(self.mas_bottom).with.offset(0);
                _statusContainerViewLeft = make.left.equalTo(self.mas_left).with.offset(86);
            }];
        }
            break;
        case UIInterfaceOrientationLandscapeRight:
        {
            [statusContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
                _statusContainerViewHeight = make.height.equalTo(self.mas_height);
                _statusContainerViewTop = make.top.equalTo(self.mas_top).with.offset(0);
                _statusContainerViewRight = make.right.equalTo(self.mas_right).with.offset(86);
                _statusContainerViewBottom = make.bottom.equalTo(self.mas_bottom).with.offset(0);
                _statusContainerViewLeft = make.left.equalTo(self.mas_left).with.offset(0);
            }];
        }
            break;
    }
}

- (void)updateConstraintsStatusView:(UIInterfaceOrientation)orientation
{
    [_statusViewWidth uninstall];
    [_statusViewHeight uninstall];
    [_statusViewTop uninstall];
    [_statusViewRight uninstall];
    [_statusViewBottom uninstall];
    [_statusViewLeft uninstall];

    switch (orientation) {
        case UIInterfaceOrientationPortrait:
        {
            [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
                _statusViewWidth = make.width.equalTo(statusView.superview.mas_width);
                _statusViewHeight = make.height.equalTo(@40);
                _statusViewTop = make.top.equalTo(statusView.superview.mas_top).with.offset(0);
                _statusViewRight = make.right.equalTo(statusView.superview.mas_right).with.offset(0);
                _statusViewLeft = make.left.equalTo(statusView.superview.mas_left).with.offset(0);
            }];
        }
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
                _statusViewWidth = make.width.equalTo(statusView.superview.mas_width);
                _statusViewHeight = make.height.equalTo(@40);
                _statusViewRight = make.right.equalTo(statusView.superview.mas_right).with.offset(0);
                _statusViewBottom = make.bottom.equalTo(statusView.superview.mas_bottom).with.offset(0);
                _statusViewLeft = make.left.equalTo(statusView.superview.mas_left).with.offset(0);
            }];
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
        {
            [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
                _statusViewWidth = make.width.equalTo(statusView.superview.mas_width);
                _statusViewHeight = make.height.equalTo(@40);
                _statusViewTop = make.top.equalTo(statusView.superview.mas_top).with.offset(0);
                _statusViewRight = make.right.equalTo(statusView.superview.mas_right).with.offset(0);
                _statusViewLeft = make.left.equalTo(statusView.superview.mas_left).with.offset(0);
            }];
        }
            break;
    }
}

@end
