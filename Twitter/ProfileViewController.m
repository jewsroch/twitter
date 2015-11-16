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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *followersCountLabel;

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
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
