//
//  CineRecordButtonView.h
//  Broadcaster
//
//  Created by Jeffrey Wescott on 6/5/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CineRecordButtonView : UIView

@property (nonatomic) BOOL enabled;
@property (nonatomic) BOOL recording;
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *horizontalSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalSpaceConstraint;

@end
