//
//  JRSLoginTableViewController.h
//  Example
//
//  Created by Sopl'Wang on 15/8/9.
//  Copyright (c) 2015年 Jrs.tv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JRSLoginTableViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITextField *roomTextField;
@property (strong, nonatomic) IBOutlet UITextField *passTextField;

@end

/*
 Move to the next screen without an animation.
 */
@interface PushNoAnimationSegue : UIStoryboardSegue

@end
