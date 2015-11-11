//
//  LoginViewController.m
//  Twitter
//
//  Created by Chad Jewsbury on 11/4/15.
//  Copyright © 2015 Chad Jewsbury. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"
#import "TweetsViewController.h"
#import "User.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (IBAction)onLogin:(id)sender {
    [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
        if (user != nil) {
            [User currentUser];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"Oh No's!: %@", error);
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Login";

    User *user = [User currentUser];
    if (user != nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
