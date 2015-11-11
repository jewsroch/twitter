//
//  TweetCell.h
//  Twitter
//
//  Created by Chad Jewsbury on 11/7/15.
//  Copyright © 2015 Chad Jewsbury. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@protocol TweetCellDelegate <NSObject>

- (void)shouldReplyToTweet:(Tweet *)tweet;

@end


@interface TweetCell : UITableViewCell

@property (strong, nonatomic) Tweet *tweet;
@property (weak, nonatomic) id<TweetCellDelegate> delegate;

@end
