//
//  ProfileViewController.m
//  Twitter
//
//  Created by Chad Jewsbury on 11/15/15.
//  Copyright © 2015 Chad Jewsbury. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *taglineLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *verifiedImage;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *urlLabel;
@property (weak, nonatomic) IBOutlet UIImageView *locationImage;
@property (weak, nonatomic) IBOutlet UIImageView *urlImage;

@end

@implementation ProfileViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.profileImageView.layer.cornerRadius = 5;
    self.profileImageView.layer.borderWidth = 5;
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImageView.clipsToBounds = YES;

    [self.profileImageView setImageWithURL:[NSURL URLWithString:self.user.profileImageUrl]];
    [self.backgroundImageView setAlpha:1];
    [self.backgroundImageView setImageWithURL:[NSURL URLWithString:self.user.backgroundImageUrl]];

    self.nameLabel.text = self.user.name;
    self.screenNameLabel.text = self.user.screenname;
    self.taglineLabel.text = self.user.tagline;
    self.followingCountLabel.text = [self formatCount:self.user.followingCount];
    self.followersCountLabel.text = [self formatCount:self.user.followersCount];

    if (![self.user.location isEqual:[NSNull null]]) {
        self.locationLabel.text = self.user.location;
        self.locationLabel.hidden = NO;
        self.locationImage.hidden = NO;
    }

    if (![self.user.url isEqual:[NSNull null]]) {
        self.urlLabel.text = self.user.url;
        self.urlLabel.hidden = NO;
        self.urlImage.hidden = NO;
    }

    if (!self.user.verified) {
        self.verifiedImage.hidden = YES;
    }
}

- (IBAction)onUrlTap:(UITapGestureRecognizer *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.user.url]];
}

- (NSString *)formatCount:(NSNumber *)count {
    NSString *formatted;
    if ([count integerValue] > 1000000) {
        formatted = [NSString stringWithFormat:@"%.1fM", [count floatValue]/1000000];
    } else if ([count integerValue] > 1000) {
        formatted = [NSString stringWithFormat:@"%.1fK", [count floatValue]/1000];
    } else {
        formatted = [NSString stringWithFormat:@"%@", count];
    }
    return formatted;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
