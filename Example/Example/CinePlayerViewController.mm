//
//  CinePlayerViewController.m
//  Example
//
//  Created by Jeffrey Wescott on 6/18/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import "CinePlayerViewController.h"
#import <cineio/CineIO.h>

@interface CinePlayerViewController ()

@end

@implementation CinePlayerViewController

@synthesize playUrlHLS;
@synthesize spinner;
@synthesize playButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    spinner.hidden = NO;
    playButton.hidden = YES;
    playButton.enabled = NO;
    [spinner startAnimating];
    
    //-- cine.io setup
    
    // read our cine.io configuration from a plist bundle
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cineio-settings" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSLog(@"settings: %@", settings);
    
    // create a new CineClient to fetch our stream information
    CineClient *cine = [[CineClient alloc] initWithSecretKey:settings[@"CINE_IO_SECRET_KEY"]];
    //[self updateStatus:@"Configuring stream using cine.io ..."];
    [cine getStream:settings[@"CINE_IO_STREAM_ID"] withCompletionHandler:^(NSError *error, CineStream *stream) {
        if (error) {
            //[self updateStatus:@"ERROR: couldn't get stream information from cine.io"];
            NSLog(@"%@", @"ERROR: couldn't get stream information from cine.io");
        } else {
            playUrlHLS = [stream playUrlHLS];
            [self startStreaming:nil];
        }
    }];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (IBAction)startStreaming:(id)sender
{
    spinner.hidden = NO;
    playButton.hidden = YES;
    playButton.enabled = NO;
    [spinner startAnimating];
    
    NSURL *url = [NSURL URLWithString:playUrlHLS];
    _moviePlayer =  [[MPMoviePlayerController alloc] initWithContentURL:url];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stoppedStreaming:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stoppedStreaming:)
                                                 name:MPMoviePlayerDidExitFullscreenNotification
                                               object:_moviePlayer];
    
    _moviePlayer.controlStyle = MPMovieControlStyleDefault;
    _moviePlayer.shouldAutoplay = YES;
    [self.view addSubview:_moviePlayer.view];
    [_moviePlayer setFullscreen:YES animated:YES];
    [spinner stopAnimating];
    spinner.hidden = YES;
}

- (void)stoppedStreaming:(NSNotification*)notification {
    playButton.enabled = YES;
    playButton.hidden = NO;

    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerDidExitFullscreenNotification
                                                  object:player];
    
    if ([player respondsToSelector:@selector(setFullscreen:animated:)]) {
        [player.view removeFromSuperview];
    }
}

@end
