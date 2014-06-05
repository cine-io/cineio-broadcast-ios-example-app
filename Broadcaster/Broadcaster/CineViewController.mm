//
//  CineViewController.m
//  Broadcaster
//
//  Created by Jeffrey Wescott on 6/4/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import "CineViewController.h"
#import <cineio/CineIO.h>

@interface CineViewController ()
{
    BOOL _recording;
    CineClient *_cine;
    CineStream *_stream;
}

-(void)setupCine:(NSDictionary *)settings;
@end

@implementation CineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // UI setup
    _recording = NO;
    [self.preview setContentMode:UIViewContentModeCenter];
    [self.preview setContentMode:UIViewContentModeScaleAspectFit];

    // cine.io setup
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cineio-settings" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSLog(@"settings: %@", settings);
    [self setupCine:settings];
}

- (void)setupCine:(NSDictionary *)settings
{
    _cine = [[CineClient alloc] initWithSecretKey:settings[@"CINE_IO_SECRET_KEY"]];
    [_cine getStreamsWithCompletionHandler:^(NSError *error, NSArray *streams) {
        _stream = (CineStream *)streams[0];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)onRecord:(id)sender
{
    NSLog(@"Record touched");
    
    if (!_recording) {
        _recording = YES;
        [self.recordButton setTitle:@"C" forState:UIControlStateNormal];
        NSString* rtmpUrl = [NSString stringWithFormat:@"%@/%@", [_stream publishUrl], [_stream publishStreamName]];
        
        pipeline.reset(new Broadcaster::CinePipeline([self](Broadcaster::SessionState state){
            [self connectionStatusChange:state];
        }));
        
        
        pipeline->setPBCallback([=](const uint8_t* const data, size_t size) {
            [self gotPixelBuffer: data withSize: size];
        });
        
        float scr_w = self.preview.bounds.size.width;
        float scr_h = self.preview.bounds.size.height;
        
        pipeline->startRtmpSession([rtmpUrl UTF8String], scr_w, scr_h, 500000 /* video bitrate */, 15 /* video fps */);
    } else {
        _recording = NO;
        // disconnect
        pipeline.reset();
        [self.recordButton setTitle:@"" forState:UIControlStateNormal];
    }
}

- (void) connectionStatusChange:(Broadcaster::SessionState) state
{
    NSLog(@"Connection status: %d", state);
    if(state == Broadcaster::kSessionStateStarted) {
        NSLog(@"Connected");
        [self.recordButton setTitle:@"O" forState:UIControlStateNormal];
        [self.recordButton.titleLabel sizeToFit];
    } else if(state == Broadcaster::kSessionStateError || state == Broadcaster::kSessionStateEnded) {
        NSLog(@"Disconnected");
        [self.recordButton setTitle:@"" forState:UIControlStateNormal];
        pipeline.reset();
    }
}

- (void) gotPixelBuffer: (const uint8_t* const) data withSize: (size_t) size {
    // TODO (JW): need this @autoreleasepool?
    @autoreleasepool {
        CVPixelBufferRef pb = (CVPixelBufferRef) data;
        float width = CVPixelBufferGetWidth(pb);
        float height = CVPixelBufferGetHeight(pb);
        NSLog(@"PixelBuffer size: %fx%f", width, height);
        CVPixelBufferLockBaseAddress(pb, 1);
        CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pb];
        
        CIContext *temporaryContext = [CIContext contextWithOptions:nil];
        CGImageRef videoImage = [temporaryContext
                                 createCGImage:ciImage
                                 fromRect:CGRectMake(0, 0, width, height)];
        
        UIImage *uiImage = [UIImage imageWithCGImage:videoImage];
        CVPixelBufferUnlockBaseAddress(pb, 0);
        
        [self.preview performSelectorOnMainThread:@selector(setImage:) withObject:uiImage waitUntilDone:NO];
        
        CGImageRelease(videoImage);
    }
}
@end
