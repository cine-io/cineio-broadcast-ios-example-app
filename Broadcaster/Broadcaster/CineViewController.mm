//
//  CineViewController.m
//  Broadcaster
//
//  Created by Jeffrey Wescott on 6/4/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import "CineViewController.h"
#import "CineBroadcasterView.h"
#import <cineio/CineIO.h>

@interface CineViewController ()
{
    CineClient *_cine;
    CineStream *_stream;
    CineBroadcasterView *_view;
}

@end

@implementation CineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // UI setup
    _view = (CineBroadcasterView *)self.view;

    // cine.io setup
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cineio-settings" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSLog(@"settings: %@", settings);
    _cine = [[CineClient alloc] initWithSecretKey:settings[@"CINE_IO_SECRET_KEY"]];
    _view.status.text = [NSString stringWithFormat:@"Getting cine.io stream info"];
    [_cine getStream:settings[@"CINE_IO_STREAM_ID"] withCompletionHandler:^(NSError *error, CineStream *stream) {
        _stream = stream;
        _view.recordButton.enabled = YES;
        _view.status.text = [NSString stringWithFormat:@"Ready"];
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

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    // once rotation is complete, turn animations back on
    [UIView setAnimationsEnabled:YES];
}

- (IBAction)onRecord:(id)sender
{
    NSLog(@"Record touched");
    
    if (!_view.recordButton.recording) {
        _view.recordButton.recording = YES;
        NSString* rtmpUrl = [NSString stringWithFormat:@"%@/%@", [_stream publishUrl], [_stream publishStreamName]];
        
        NSLog(@"%@", rtmpUrl);
        _view.status.text = [NSString stringWithFormat:@"Connecting to %@", rtmpUrl];

        
        pipeline.reset(new Broadcaster::CinePipeline([self](Broadcaster::SessionState state){
            [self connectionStatusChange:state];
        }));
        
        
        pipeline->setPBCallback([=](const uint8_t* const data, size_t size) {
            [self gotPixelBuffer: data withSize: size];
        });
        
        float scr_w = _view.cameraView.bounds.size.width;
        float scr_h = _view.cameraView.bounds.size.height;
        
        pipeline->startRtmpSession([rtmpUrl UTF8String], scr_w, scr_h, 500000 /* video bitrate */, 15 /* video fps */);
    } else {
        _view.recordButton.recording = NO;
        // disconnect
        pipeline.reset();
    }
}

- (void) connectionStatusChange:(Broadcaster::SessionState) state
{
    NSLog(@"Connection status: %d", state);
    if(state == Broadcaster::kSessionStateStarted) {
        NSLog(@"Connected");
        _view.status.text = [NSString stringWithFormat:@"Connected"];
    } else if(state == Broadcaster::kSessionStateError || state == Broadcaster::kSessionStateEnded) {
        NSLog(@"Disconnected");
        _view.status.text = [NSString stringWithFormat:@"Disconnected"];
        pipeline.reset();
    } else {
        NSLog(@"%u", state);
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
        
        [_view.cameraView performSelectorOnMainThread:@selector(setImage:) withObject:uiImage waitUntilDone:NO];
        
        CGImageRelease(videoImage);
    }
}
@end
