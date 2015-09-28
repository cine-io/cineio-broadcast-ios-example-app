//
//  JRSSettingTableViewController.m
//  Example
//
//  Created by Sopl'Wang on 15/8/7.
//  Copyright (c) 2015年 Jrs.tv. All rights reserved.
//

#import "JRSSettingsTableViewController.h"
#import <cineio/CineIO.h>

@interface JRSSettingsTableViewController ()

@end

@implementation JRSSettingsTableViewController {
    CineClient *_cineClient;
    NSString *_cineStreamId;
}

- (void)viewDidLoad {
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.tabBarController.navigationItem.title = @"Settings";
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    [_cineClient getStream:_cineStreamId withCompletionHandler:^(NSError *error, CineStream *stream) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Get Stream Error"
                                                            message:@"ERROR: couldn't get stream information from jrs.tv"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        } else {
            UITableViewCell *cell;

            cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell.detailTextLabel.text = stream.name;
            cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            cell.detailTextLabel.text = stream.publishUrl;
            cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            cell.detailTextLabel.text = stream.publishStreamName;
            cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
            cell.detailTextLabel.text = stream.playUrlHLS;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- select row

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if ([[cell reuseIdentifier] isEqualToString:@"LogoutCell"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"JRSTV_ROOM_ID"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"JRSTV_ROOM_PASS"];

        [self.navigationController popToRootViewControllerAnimated:YES];
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
