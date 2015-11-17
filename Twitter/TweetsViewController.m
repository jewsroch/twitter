//
//  TweetsViewController.m
//  Twitter
//
//  Created by Chad Jewsbury on 11/5/15.
//  Copyright © 2015 Chad Jewsbury. All rights reserved.
//

#import "TweetsViewController.h"
#import "LoginViewController.h"
#import "TweetViewController.h"
#import "CreateViewController.h"
#import "TwitterClient.h"
#import "User.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "ProfileViewController.h"

@interface TweetsViewController () <UITableViewDelegate, UITableViewDataSource, TweetCellDelegate, TweetViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *tweets;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon-Small-50"]];

    [self setupNavigationBar];
    [self setupTableView];

    User *user = [User currentUser];

    // Check if user is already logged in. Show Tweets if so, Show Login if not.
    if (user != nil) {
        [self fetchTweets];

        self.refreshControl = [[UIRefreshControl alloc] init];
        [self.refreshControl addTarget:self
                                action:@selector(fetchTweets)
                      forControlEvents:UIControlEventValueChanged];
        [self.tableView insertSubview:self.refreshControl atIndex: 0];

    } else {
        self.tweets = [NSArray array];
        [self.tableView reloadData];
        [self showLogin];
    }
}


#pragma mark - Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.tweets.count) {
        return self.tweets.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tweetCell"];
    cell.delegate = self;
    cell.tweet = self.tweets[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    TweetViewController *vc = [[TweetViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
    vc.tweet = self.tweets[indexPath.row];
}

- (void)setupTableView {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"tweetCell"];
    self.tableView.estimatedRowHeight = 60;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)shouldReplyToTweet:(Tweet *)tweet {
    CreateViewController *vc = [[CreateViewController alloc] init];
    vc.retweetTweet = tweet;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)shouldShowProfile:(User *)user {
    ProfileViewController *vc = [[ProfileViewController alloc] init];
    vc.user = user;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupNavigationBar {
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"]
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self action:@selector(onMenu)];

    UIBarButtonItem *tweet = [[UIBarButtonItem alloc] initWithTitle:@"Tweet"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(onTweet)];
    self.navigationItem.leftBarButtonItem = logoutButton;

//    [self.navigationItem.leftBarButtonItem setTarget:self.menuNavitationController]
//    [self.navigationItem.leftBarButtonItem setAction:@selector(//action name)]
    self.navigationItem.rightBarButtonItem = tweet;
}

- (void)fetchTweets {

    [Tweet homeTimelineWithCompletion:self.isMentions completion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.tweets = tweets;
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        } else if (error) {
            NSLog(@"Error: %@", error);
            [self.refreshControl endRefreshing];
        }
    }];
}

- (void)onMenu {
    // Open Menu
}

- (void)onTweet {
    CreateViewController *vc = [[CreateViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)showLogin {
    LoginViewController *lvc = [[LoginViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:lvc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onLogout {
    [User logout];
}

- (void)viewWillAppear:(BOOL)animated {
//    [self fetchTweets];
//    NSLog(@"Refreshing tweets...");
}

@end
