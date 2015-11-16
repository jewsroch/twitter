//
//  MainViewController.h
//  Twitter
//
//  Created by Chad Jewsbury on 11/14/15.
//  Copyright © 2015 Chad Jewsbury. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

@property (nonatomic, strong) UINavigationController *menuViewController;
@property (nonatomic, strong) UINavigationController *contentViewController;

- (void)open;
- (void)close;

@end
