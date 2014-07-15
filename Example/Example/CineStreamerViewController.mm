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

@implementation CineStreamerViewController

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
    CineClient *cine = [[CineClient alloc] initWithSecretKey:settings[@"CINE_IO_SECRET_KEY"]];
    [cine getStream:settings[@"CINE_IO_STREAM_ID"] withCompletionHandler:^(NSError *error, CineStream *stream) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network error"
                                                            message:@"Couldn't get stream settings from cine.io."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        } else {
            self.stream = stream;
        }
    }];
}

- (IBAction)playButtonPressed:(id)sender
{
    playButton.enabled = NO;
    playButton.hidden = YES;
    [self startStreaming];
}

- (void)finishStreaming
{
    playButton.hidden = NO;
    playButton.enabled = YES;
}

- (BOOL)shouldAutorotate {
    return YES;
}

@end
