//
//  CineViewController.m
//  Broadcaster
//
//  Created by Jeffrey Wescott on 6/4/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import "CineViewController.h"
#import <cineio/CineIO.h>
#import <AVFoundation/AVFoundation.h>

@interface CineViewController ()
{
    CineClient *_cine;
    CineStream *_stream;
}

@end

@implementation CineViewController

@synthesize broadcasterView;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // cine.io setup
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cineio-settings" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSLog(@"settings: %@", settings);
    _cine = [[CineClient alloc] initWithSecretKey:settings[@"CINE_IO_SECRET_KEY"]];
    broadcasterView.status.text = [NSString stringWithFormat:@"Getting cine.io stream info"];
    [_cine getStream:settings[@"CINE_IO_STREAM_ID"] withCompletionHandler:^(NSError *error, CineStream *stream) {
        _stream = stream;
        broadcasterView.recordButton.enabled = YES;
        broadcasterView.status.text = [NSString stringWithFormat:@"Ready"];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
                               duration:(NSTimeInterval)duration {
    // we don't want to animate during re-layout due to orientation changes
    [UIView setAnimationsEnabled:NO];
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                        duration:(NSTimeInterval)duration {
    [broadcasterView setNeedsUpdateConstraints];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    // once rotation is complete, turn animations back on
    [UIView setAnimationsEnabled:YES];
    NSLog(@"broadcasterView: %.0fx%.0f", broadcasterView.frame.size.width, broadcasterView.frame.size.height);
    NSLog(@"cameraView: %.0fx%.0f", broadcasterView.cameraView.frame.size.width, broadcasterView.cameraView.frame.size.height);
}

- (IBAction)onRecord:(id)sender
{
    NSLog(@"Record touched");
    
    if (!broadcasterView.recordButton.recording) {
        broadcasterView.recordButton.recording = YES;
        NSString* rtmpUrl = [NSString stringWithFormat:@"%@/%@", [_stream publishUrl], [_stream publishStreamName]];
        
        NSLog(@"%@", rtmpUrl);
        broadcasterView.status.text = [NSString stringWithFormat:@"Connecting to %@", rtmpUrl];

        
        pipeline.reset(new Broadcaster::CinePipeline([self](Broadcaster::SessionState state){
            [self connectionStatusChange:state];
        }));
        
        
        pipeline->setPBCallback([=](const uint8_t* const data, size_t size) {
            [self gotPixelBuffer: data withSize: size];
        });
        
        float scr_w = broadcasterView.cameraView.bounds.size.width;
        float scr_h = broadcasterView.cameraView.bounds.size.height;

        pipeline->startRtmpSession([rtmpUrl UTF8String], scr_w, scr_h, 1500000 /* video bitrate */, 30 /* video fps */);
    } else {
        broadcasterView.recordButton.recording = NO;
        // disconnect
        pipeline.reset();
    }
}

- (void) connectionStatusChange:(Broadcaster::SessionState) state
{
    NSLog(@"Connection status: %d", state);
    if(state == Broadcaster::kSessionStateStarted) {
        NSLog(@"Connected");
        broadcasterView.status.text = [NSString stringWithFormat:@"Connected"];
    } else if(state == Broadcaster::kSessionStateError || state == Broadcaster::kSessionStateEnded) {
        NSLog(@"Disconnected");
        broadcasterView.status.text = [NSString stringWithFormat:@"Disconnected"];
        pipeline.reset();
    }
}

- (void) gotPixelBuffer: (const uint8_t* const) data withSize: (size_t) size {
    // TODO (JW): need this @autoreleasepool?
    @autoreleasepool {
        CVPixelBufferRef pb = (CVPixelBufferRef) data;
        float width = CVPixelBufferGetWidth(pb);
        float height = CVPixelBufferGetHeight(pb);
        CVPixelBufferLockBaseAddress(pb, 1);
        CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pb];
        
        CIContext *temporaryContext = [CIContext contextWithOptions:nil];
        CGImageRef videoImage = [temporaryContext
                                 createCGImage:ciImage
                                 fromRect:CGRectMake(0, 0, width, height)];
        
        UIImage *uiImage = [UIImage imageWithCGImage:videoImage];
        CVPixelBufferUnlockBaseAddress(pb, 0);
        
        [broadcasterView.cameraView performSelectorOnMainThread:@selector(setImage:) withObject:uiImage waitUntilDone:NO];
        
        CGImageRelease(videoImage);
    }
}
@end
