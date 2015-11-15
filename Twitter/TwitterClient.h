//
//  TwitterClient.h
//  Twitter
//
//  Created by Chad Jewsbury on 11/4/15.
//  Copyright © 2015 Chad Jewsbury. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"
#import "Tweet.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)sharedInstance;

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion;
- (void)openURL:(NSURL *)url;

- (void)homeTimelineWithParams:(NSDictionary *)params
                    completion:(void (^)(NSArray *tweets, NSError *error))completion;
- (void)updateStatusWithParams:(NSDictionary *)params
                    completion:(void (^)(NSDictionary *responseObject, NSError *error))completion;
- (void)retweetWithParams:(NSDictionary *)params tweetId:(NSInteger)tweetId
               completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)favoriteTweetWithId:(NSInteger)tweetId
               errorHandler:(void (^)(NSArray *responseObject, NSError *error))errorHandler;
- (void)deleteFavoriteTweetWithId:(NSInteger)tweetId
                     errorHandler:(void (^)(NSArray *responseObject, NSError *error))errorHandler;

@end
