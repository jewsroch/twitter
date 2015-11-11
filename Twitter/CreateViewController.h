//
//  CreateViewController.h
//  Twitter
//
//  Created by Chad Jewsbury on 11/8/15.
//  Copyright © 2015 Chad Jewsbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Tweet.h"

@interface CreateViewController : UIViewController

@property (strong, nonatomic) User *user;
@property (strong, nonatomic) Tweet *retweetTweet;

@end
