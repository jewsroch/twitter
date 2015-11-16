//
//  MenuViewController.m
//  Twitter
//
//  Created by Chad Jewsbury on 11/14/15.
//  Copyright © 2015 Chad Jewsbury. All rights reserved.
//

#import "MenuViewController.h"
#import "MainViewController.h"
#import "TweetsViewController.h"
#import "ProfileViewController.h"
#import "MenuCell.h"
#import "User.h"

@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *menuViewControllers;
@property (strong, nonatomic) UINavigationController *nvcHome;
@property (strong, nonatomic) UINavigationController *nvcMentions;
@property (strong, nonatomic) UINavigationController *nvcProfile;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupViewControllers];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)setupViewControllers {
    TweetsViewController *tvc = [[TweetsViewController alloc] init];
    self.nvcHome = [[UINavigationController alloc] initWithRootViewController:tvc];

    TweetsViewController *mvc = [[TweetsViewController alloc] init];
    mvc.isMentions = YES;
    self.nvcMentions = [[UINavigationController alloc] initWithRootViewController:mvc];

    ProfileViewController *pvc = [[ProfileViewController alloc] init];
    pvc.user = [User currentUser];
    self.nvcProfile = [[UINavigationController alloc] initWithRootViewController:pvc];

    self.menuViewControllers = @[self.nvcHome, self.nvcProfile, self.nvcMentions];
}

- (void)setupTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"MenuCell" bundle:nil] forCellReuseIdentifier:@"menuCell"];
    self.tableView.rowHeight = 100;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        [User logout];
    } else {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        MainViewController *mvc = (MainViewController *)self.mainViewController;
        mvc.contentViewController = self.menuViewControllers[indexPath.row];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];
    cell.menuLabel.text = @[@"Home", @"Profile", @"Mentions", @"Sign Out"][indexPath.row];
    return cell;
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
