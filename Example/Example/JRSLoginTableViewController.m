//
//  JRSLoginTableViewController.m
//  Example
//
//  Created by Sopl'Wang on 15/8/9.
//  Copyright (c) 2015年 Jrs.tv. All rights reserved.
//

#import "JRSLoginTableViewController.h"
#import <cineio/CineIO.h>

#pragma mark - JRSLoginTableViewController

@interface JRSLoginTableViewController ()

@end

@implementation JRSLoginTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _roomTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_roomTextField.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
    _passTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_passTextField.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:YES];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _roomTextField.text = [defaults stringForKey:@"JRSTV_ROOM_ID"];
    _passTextField.text = [defaults stringForKey:@"JRSTV_ROOM_PASS"];

    [_roomTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- select row

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if ([[cell reuseIdentifier] isEqualToString:@"LoginCell"]) {
        //-- cine.io setup
        // read our cine.io configuration from a plist bundle
        NSString *path = [[NSBundle mainBundle] pathForResource:@"cineio-settings" ofType:@"plist"];
        NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
        NSLog(@"settings: %@", settings);

        // create a new CineClient to fetch our stream information
        CineClient *cine = [[CineClient alloc] init];
        cine.projectSecretKey = settings[@"CINE_IO_PROJECT_SECRET_KEY"];

        NSString *streamId = [@[_roomTextField.text, _passTextField.text] componentsJoinedByString:@":"];
        [cine getStream:streamId withCompletionHandler:^(NSError *error, CineStream *stream) {
            if (error) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login failed"
                                                                message:@"ERROR: couldn't get stream information from jrs.tv"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            } else {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:_roomTextField.text forKey:@"JRSTV_ROOM_ID"];
                [defaults setObject:_passTextField.text forKey:@"JRSTV_ROOM_PASS"];

                [self performSegueWithIdentifier:@"main" sender:self];
            }
        }];
    }
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

#pragma mark - PushNoAnimationSegue

@implementation PushNoAnimationSegue

- (void) perform {
    [[self.sourceViewController navigationController] pushViewController:self.destinationViewController animated:NO];
}

@end
