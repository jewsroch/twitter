//
//  TweetViewController.m
//  Twitter
//
//  Created by Chad Jewsbury on 11/8/15.
//  Copyright © 2015 Chad Jewsbury. All rights reserved.
//

#import "TweetViewController.h"
#import "UIImageView+AFNetworking.h"

@interface TweetViewController ()

@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;

@end

@implementation TweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setTweet:self.tweet];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    self.tweetLabel.text = _tweet.text;
    self.userNameLabel.text = _tweet.user.name;
    self.userScreenNameLabel.text = [NSString stringWithFormat:@"@%@",_tweet.user.name];
    NSLog(@"****URL: %@", _tweet.user.profileImageUrl);
    [self.userProfileImage setImageWithURL:[NSURL URLWithString:_tweet.user.profileImageUrl] placeholderImage:[UIImage imageNamed:@"Twitter"]];
    self.userProfileImage.layer.cornerRadius = 5;
    self.userProfileImage.clipsToBounds = YES;
}

@end
