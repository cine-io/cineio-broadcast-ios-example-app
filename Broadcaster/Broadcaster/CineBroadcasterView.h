//
//  CineBroadcasterView.h
//  Broadcaster
//
//  Created by Jeffrey Wescott on 6/6/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CineRecordButtonView.h"

@interface CineBroadcasterView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *cameraView;

@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UILabel *status;

@property (weak, nonatomic) IBOutlet UIView *controlsView;
@property (weak, nonatomic) IBOutlet CineRecordButtonView *recordButton;

- (void)updateConstraints:(UIInterfaceOrientation)orientation;

@end
