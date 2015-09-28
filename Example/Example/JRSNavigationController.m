//
//  JRSNavigationController.m
//  Example
//
//  Created by Sopl'Wang on 15/8/17.
//  Copyright (c) 2015年 Jrs.tv. All rights reserved.
//

#import "JRSNavigationController.h"

@interface JRSNavigationController ()

@end

@implementation JRSNavigationController

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
