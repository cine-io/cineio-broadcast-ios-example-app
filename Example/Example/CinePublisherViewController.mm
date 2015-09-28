//
//  CinePublisherViewController.m
//  Example
//
//  Created by Jeffrey Wescott on 6/4/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import "CinePublisherViewController.h"
#import <cineio/CineIO.h>
#import <AVFoundation/AVFoundation.h>

@interface CinePublisherViewController ()

@end

@implementation CinePublisherViewController {
    CineClient *_cineClient;
    NSString *_cineStreamId;
}

- (void)viewDidLoad
{
    //-- A/V setup
    self.orientationLocked = NO; // set to YES to turn off rotation support in UI
    self.videoSize = CGSizeMake(1280, 720);
    self.framesPerSecond = 25;
    self.videoBitRate = 700000;
    self.sampleRateInHz = 44100; // either 44100 or 22050

    // must be called _after_ we set up our properties, as our superclass
    // will use them in its viewDidLoad method
    [super viewDidLoad];
    
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

    [self updateStatus:@"Configuring stream using jrs.tv..."];
    [cine getStream:streamId withCompletionHandler:^(NSError *error, CineStream *stream) {
        if (error) {
            [self updateStatus:@"ERROR: couldn't get stream information from jrs.tv"];
        } else {
            self.publishUrl = [stream publishUrl];
            self.publishStreamName = [stream publishStreamName];

            // once we've fully-configured our properties, we can enable the
            // UI controls on our view
            [self enableControls];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)toggleStreaming:(id)sender
{
    switch (self.streamState) {
        case CineStreamStateNone:
        case CineStreamStatePreviewStarted:
        case CineStreamStateEnded:
        case CineStreamStateError:
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
            break;

        default:
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
            // stop the actual stream
            [super toggleStreaming:sender];
            return;
    }

    [self updateStatus:@"Configuring stream using jrs.tv..."];
    [_cineClient getStream:_cineStreamId withCompletionHandler:^(NSError *error, CineStream *stream) {
        if (error) {
            [self updateStatus:@"ERROR: couldn't get stream information from jrs.tv"];
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];

        } else {
            self.publishUrl = [stream publishUrl];
            self.publishStreamName = [stream publishStreamName];
            // start the actual stream
            [super toggleStreaming:sender];
        }
    }];
}

@end
