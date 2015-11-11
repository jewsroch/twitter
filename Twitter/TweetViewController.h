//
//  TweetViewController.h
//  Twitter
//
//  Created by Chad Jewsbury on 11/8/15.
//  Copyright © 2015 Chad Jewsbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@protocol TweetViewControllerDelegate <NSObject>

- (void)shouldReplyToTweet:(Tweet *)tweet;

@end

@interface TweetViewController : UIViewController

@property (strong, nonatomic) Tweet *tweet;
@property (weak, nonatomic) id<TweetViewControllerDelegate> delegate;


@end
