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
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoritesCountLabel;


@end

@implementation TweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setTweet:self.tweet];
}

- (IBAction)onRetweet:(id)sender {
    // Move this to trigger a delegate on the Tweet event.
    [self.tweet rewtweetWithParams:nil completion:^(Tweet *tweet, NSError *error) {
        if (tweet) {
            self.tweet.retweetsCount ++;
            self.retweetCountLabel.text = [@(self.tweet.retweetsCount) stringValue];
        } else {
            // Already retweeted. Undo retweet.
        }
    }];
}

- (IBAction)onLike:(id)sender {
    [self.tweet favoriteTweetWithId:self.tweet.tweetId completion:^(Tweet *tweet, NSError *error) {
        if (tweet) {
            self.tweet.favoritesCount ++;
            self.favoritesCountLabel.text = [@(self.tweet.favoritesCount) stringValue];
        } else {
            // Already favorited...
            // Unfavorite this...
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    self.tweetLabel.text = _tweet.text;
    self.userNameLabel.text = _tweet.user.name;
    self.retweetCountLabel.text = [@(_tweet.retweetsCount) stringValue];
    self.favoritesCountLabel.text = [@(_tweet.favoritesCount) stringValue];
    self.userScreenNameLabel.text = [NSString stringWithFormat:@"@%@",_tweet.user.name];
    [self.userProfileImage setImageWithURL:[NSURL URLWithString:_tweet.user.profileImageUrl] placeholderImage:[UIImage imageNamed:@"Twitter"]];
    self.userProfileImage.layer.cornerRadius = 5;
    self.userProfileImage.clipsToBounds = YES;
}

@end
