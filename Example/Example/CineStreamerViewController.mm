//
//  CineStreamerViewController.m
//  Example
//
//  Created by Jeffrey Wescott on 6/18/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import "CineStreamerViewController.h"
#import <cineio/CineIO.h>

@interface CineStreamerViewController ()

@end

@implementation CineStreamerViewController {
    CineClient *_cineClient;
    NSString *_cineStreamId;
}

@synthesize playButton;

- (void)viewDidLoad
{
    [super viewDidLoad];

    playButton.hidden = NO;
    playButton.enabled = YES;
    
    //-- cine.io setup
    // read our cine.io configuration from a plist bundle
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cineio-settings" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSLog(@"settings: %@", settings);
    
    // create a new CineClient to fetch our stream information
    CineClient *cine = [[CineClient alloc] init];
    cine.projectSecretKey = settings[@"CINE_IO_PROJECT_SECRET_KEY"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *streamId = [@[[defaults stringForKey:@"JRSTV_ROOM_ID"], [defaults stringForKey:@"JRSTV_ROOM_PASS"]] componentsJoinedByString:@":"];
    
    _cineClient = cine;
    _cineStreamId = streamId;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)playButtonPressed:(id)sender
{
    playButton.enabled = NO;
    playButton.hidden = YES;
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    [_cineClient getStream:_cineStreamId withCompletionHandler:^(NSError *error, CineStream *stream) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Get Stream Error"
                                                            message:@"Couldn't get stream settings from jrs.tv."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [self finishStreaming];
        } else {
            self.stream = stream;
            [self startStreaming];
        }
    }];
}

- (void)finishStreaming
{
    [super finishStreaming];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    playButton.hidden = NO;
    playButton.enabled = YES;
}

@end
