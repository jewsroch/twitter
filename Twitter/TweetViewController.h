//
//  TweetViewController.h
//  Twitter
//
//  Created by Chad Jewsbury on 11/8/15.
//  Copyright © 2015 Chad Jewsbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "User.h"

@protocol TweetViewControllerDelegate <NSObject>

- (void)shouldReplyToTweet:(Tweet *)tweet;
- (void)shouldShowProfile:(User *)user;

@end

@interface TweetViewController : UIViewController

@property (strong, nonatomic) Tweet *tweet;
@property (weak, nonatomic) id<TweetViewControllerDelegate> delegate;


@end
