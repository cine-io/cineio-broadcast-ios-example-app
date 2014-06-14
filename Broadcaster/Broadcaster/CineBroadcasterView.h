//
//  CineBroadcasterView.h
//  Broadcaster
//
//  Created by Jeffrey Wescott on 6/6/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CineControlsView.h"

@interface CineBroadcasterView : UIView

@property (nonatomic) UIImageView *cameraView;

@property (nonatomic) UIView *statusView;
@property (nonatomic) UILabel *status;

@property (nonatomic) CineControlsView *controlsView;

@end
