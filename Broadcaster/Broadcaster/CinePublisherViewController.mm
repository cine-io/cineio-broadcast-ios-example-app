//
//  CinePublisherViewController.m
//  Broadcaster
//
//  Created by Jeffrey Wescott on 6/4/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import "CinePublisherViewController.h"
#import <cineio/CineIO.h>
#import <AVFoundation/AVFoundation.h>

@interface CinePublisherViewController ()

@end

@implementation CinePublisherViewController

// CineBroadcasterProtocol
@synthesize frameWidth;
@synthesize frameHeight;
@synthesize framesPerSecond;
@synthesize videoBitRate;
@synthesize numAudioChannels;
@synthesize sampleRateInHz;

@synthesize publishUrl;
@synthesize publishStreamName;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //-- A/V setup
    self.frameWidth = 1280;
    self.frameHeight = 720;
    self.framesPerSecond = 30;
    self.videoBitRate = 1500000;
    self.numAudioChannels = 2;
    self.sampleRateInHz = 44100;

    //-- cine.io setup

    // read our cine.io configuration from a plist bundle
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cineio-settings" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSLog(@"settings: %@", settings);
    
    // create a new CineClient to fetch our stream information
    CineClient *cine = [[CineClient alloc] initWithSecretKey:settings[@"CINE_IO_SECRET_KEY"]];
    [self updateStatus:@"Configuring stream using cine.io ..."];
    [cine getStream:settings[@"CINE_IO_STREAM_ID"] withCompletionHandler:^(NSError *error, CineStream *stream) {
        if (error) {
            [self updateStatus:@"ERROR: couldn't get stream information from cine.io"];
        } else {
            self.publishUrl = [stream publishUrl];
            self.publishStreamName = [stream publishStreamName];

            // once we've fully-configured our properties, we can enable the
            // UI controls on our view
            [self enableControls];
        }
    }];
}

@end
