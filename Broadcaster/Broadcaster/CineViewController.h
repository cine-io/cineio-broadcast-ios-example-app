//
//  CineViewController.h
//  Broadcaster
//
//  Created by Jeffrey Wescott on 6/4/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CinePipeline.h"

@interface CineViewController : UIViewController
{
    std::unique_ptr<Broadcaster::CinePipeline> pipeline;
}

- (IBAction)onRecord:(id)sender;

@end
