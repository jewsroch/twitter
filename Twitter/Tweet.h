//
//  Tweet.h
//  Twitter
//
//  Created by Chad Jewsbury on 11/4/15.
//  Copyright © 2015 Chad Jewsbury. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (nonatomic, assign) NSInteger tweetId;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) User *user;
@property (nonatomic, assign) NSInteger retweetsCount;
@property (nonatomic, assign) NSInteger favoritesCount;
@property (nonatomic, assign) BOOL retweeted;
@property (nonatomic, assign) BOOL favorited;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (void)retweetWithParams:(NSDictionary *)params completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)toggleLikeWithCompletion:(void (^)(Tweet *tweet, NSError *error))completion;

+ (NSArray *)tweetsWithArray:(NSArray *)array;
+ (void)homeTimelineWithCompletion:(void (^)(NSArray *tweets, NSError *error))completion;
+ (void)updateStatusWithParams:(NSDictionary *)params completion:(void (^)(Tweet *tweet, NSError *error))completion;

@end
