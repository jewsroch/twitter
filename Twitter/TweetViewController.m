//
//  TweetViewController.m
//  Twitter
//
//  Created by Chad Jewsbury on 11/8/15.
//  Copyright © 2015 Chad Jewsbury. All rights reserved.
//

#import "TweetViewController.h"
#import "UIImageView+AFNetworking.h"
#import "UIColor+TwitterColors.h"
#import "ProfileViewController.h"

@interface TweetViewController ()

@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoritesCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeStampLabel;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation TweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setTweet:self.tweet];

    // http://stackoverflow.com/questions/19124922/uicollectionview-adding-single-tap-gesture-recognizer-to-supplementary-view
    self.userProfileImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onProfileImageTap:)];
//    tgr.delegate = self;
    [self.userProfileImage addGestureRecognizer:tgr];
}

- (void)onProfileImageTap:(UITapGestureRecognizer *)sender {
    ProfileViewController *vc = [[ProfileViewController alloc] init];
    vc.user = self.tweet.user;
    [self.delegate shouldShowProfile:self.tweet.user];
}


- (IBAction)onReply:(id)sender {
    [self.delegate shouldReplyToTweet:self.tweet];
}

- (IBAction)onRetweet:(id)sender {
    // Move this to trigger a delegate on the Tweet event.
    [self.tweet retweetWithParams:nil completion:^(Tweet *tweet, NSError *error) {
        if (tweet) {
            self.tweet.retweetsCount ++;
            self.tweet.retweeted = YES;
            self.retweetCountLabel.text = [@(self.tweet.retweetsCount) stringValue];
            [self setRetweetButtonStatus];
        } else {
            [self setRetweetButtonStatus];
            // Already retweeted. Undo retweet.
        }
    }];
}

- (IBAction)onLike:(id)sender {
    [self.tweet toggleLikeWithCompletion:nil];
    [self updateLikes];
}

- (void)updateLikes {
    NSString *favoritesCountString = @"0";
    if (_tweet.favoritesCount > 0) {
        favoritesCountString = [NSString stringWithFormat:@"%ld", (long)_tweet.favoritesCount];
    }
    self.favoritesCountLabel.text = favoritesCountString;
    [self setFavoriteButtonStatus];
}

- (void)setFavoriteButtonStatus {
    if (self.tweet.favorited && self.tweet.favoritesCount > 0) {
        self.favoritesCountLabel.textColor = [UIColor twitterLikeActionButtonOnColor];
        self.favoriteButton.tintColor = [UIColor twitterLikeActionButtonOnColor];
    } else {
        self.favoritesCountLabel.textColor = [UIColor twitterActionButtonColor];
        self.favoriteButton.tintColor = [UIColor twitterActionButtonColor];
    }
}

- (void)setRetweetButtonStatus {
    if (self.tweet.retweeted && self.tweet.retweetsCount > 0) {
        self.retweetCountLabel.textColor = [UIColor twitterActionButtonOnColor];
        self.retweetButton.tintColor = [UIColor twitterActionButtonOnColor];
    } else {
        self.retweetCountLabel.textColor = [UIColor twitterActionButtonColor];
        self.retweetButton.tintColor = [UIColor twitterActionButtonColor];
    }
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
    self.timeStampLabel.text = _tweet.createdAt;
    [self setFavoriteButtonStatus];
    [self setRetweetButtonStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
