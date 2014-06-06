//
//  CineRecordButtonView.m
//  Broadcaster
//
//  Created by Jeffrey Wescott on 6/5/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import "CineRecordButtonView.h"

@implementation CineRecordButtonView

@synthesize recording = _recording;

-(void)awakeFromNib
{
    self.layer.cornerRadius = 36;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 5.5;
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.button.layer.cornerRadius = 28;
    self.button.layer.masksToBounds = YES;
    self.button.enabled = YES;
}

-(BOOL)getEnabled
{
    return self.button.enabled;
}

-(void)setEnabled:(BOOL)enabled
{
    self.button.enabled = enabled;
    if (enabled) {
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.button setBackgroundColor:[UIColor redColor]];
    } else {
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self.button setBackgroundColor:[UIColor grayColor]];
    }
}

-(void)setRecording:(BOOL)recording
{
    _recording = recording;
    if (recording) {
        self.buttonWidthConstraint.constant = 40;
        self.buttonHeightConstraint.constant = 40;
        self.horizontalSpaceConstraint.constant = 16;
        self.verticalSpaceConstraint.constant = 16;
        self.button.layer.cornerRadius = 10;
    } else {
        self.buttonWidthConstraint.constant = 56;
        self.buttonHeightConstraint.constant = 56;
        self.horizontalSpaceConstraint.constant = 8;
        self.verticalSpaceConstraint.constant = 8;
        self.button.layer.cornerRadius = 28;
    }

}

@end
