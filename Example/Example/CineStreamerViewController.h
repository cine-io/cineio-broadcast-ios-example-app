//
//  CineStreamerViewController.h
//  Example
//
//  Created by Jeffrey Wescott on 6/18/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <cineio/CineIO.h>

@interface CineStreamerViewController : CinePlayerViewController

@property (weak, nonatomic) IBOutlet UIButton *playButton;
- (IBAction)playButtonPressed:(id)sender;

@end
