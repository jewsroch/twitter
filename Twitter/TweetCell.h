//
//  TweetCell.h
//  Twitter
//
//  Created by Chad Jewsbury on 11/7/15.
//  Copyright © 2015 Chad Jewsbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "User.h"

@protocol TweetCellDelegate <NSObject>

- (void)shouldReplyToTweet:(Tweet *)tweet;

@optional
- (void)shouldShowProfile:(User *)user;

@end


@interface TweetCell : UITableViewCell

@property (strong, nonatomic) Tweet *tweet;
@property (weak, nonatomic) id<TweetCellDelegate> delegate;

@end
