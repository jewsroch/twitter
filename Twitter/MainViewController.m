//
//  MainViewController.m
//  Twitter
//
//  Created by Chad Jewsbury on 11/14/15.
//  Copyright © 2015 Chad Jewsbury. All rights reserved.
//

#import "MainViewController.h"
#import "MenuViewController.h"
#import "TweetsViewController.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMarginConstraint;
@property (strong, nonatomic) UINavigationController *tweetsViewController;
@property (assign, nonatomic) CGFloat originalLeftMargin;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.menuViewController = [[MenuViewController alloc] init];
    self.tweetsViewController = [[UINavigationController alloc] initWithRootViewController:[[TweetsViewController alloc] init]];

    [self.menuView addSubview:self.menuViewController.view];

    self.tweetsViewController.view.frame = self.contentView.frame;
    [self.contentView addSubview:self.tweetsViewController.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onPanGesture:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.view];
    CGPoint velocity = [sender velocityInView:self.view];
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.originalLeftMargin = self.leftMarginConstraint.constant;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        self.leftMarginConstraint.constant = self.originalLeftMargin + translation.x;
    } else if (sender.state == UIGestureRecognizerStateEnded) {

        [UIView animateWithDuration:0.3 animations:^{
            if (velocity.x > 0) {
                self.leftMarginConstraint.constant = self.view.frame.size.width - 100;
            } else {
                self.leftMarginConstraint.constant = 0;
            }
            [self.view layoutIfNeeded];
        }];
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