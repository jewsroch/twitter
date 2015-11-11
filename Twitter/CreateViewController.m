//
//  CreateViewController.m
//  Twitter
//
//  Created by Chad Jewsbury on 11/8/15.
//  Copyright © 2015 Chad Jewsbury. All rights reserved.
//

#import "CreateViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"
#import "User.h"

@interface CreateViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *textInput;

@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    [self setupNavigationBar];

    self.user = [User currentUser];
    self.nameLabel.text = self.user.name;
    self.screenNameLabel.text = self.user.screenname;

    if (self.retweetTweet) {
        self.textInput.text = [NSString stringWithFormat:@"@%@", self.retweetTweet.user.screenname];
    }

    [self.textInput becomeFirstResponder];
    [self.profileImage setImageWithURL:[NSURL URLWithString:self.user.profileImageUrl] placeholderImage:[UIImage imageNamed:@"Twitter"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupNavigationBar {
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(onCancel)];

    UIBarButtonItem *tweet = [[UIBarButtonItem alloc] initWithTitle:@"Tweet"
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(onTweet)];
    self.navigationItem.leftBarButtonItem = cancel;
    self.navigationItem.rightBarButtonItem = tweet;

}

- (void)onCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onTweet {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    if (self.retweetTweet) {
        params[@"in_reply_to_status_id"] = @(self.retweetTweet.tweetId);
    }

    NSMutableString *status = [self.textInput.text mutableCopy];
    if (status.length > 140) {
        status = [[status substringToIndex:140] mutableCopy];
    }

    params[@"status"] = status;

    [Tweet updateStatusWithParams:params completion:^(Tweet *tweet, NSError *error) {
        if (tweet) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"ERROR!: %@", error);
        }
    }];
}

@end
