//
//  Tweet.m
//  Twitter
//
//  Created by Chad Jewsbury on 11/4/15.
//  Copyright © 2015 Chad Jewsbury. All rights reserved.
//

#import "Tweet.h"
#import "TwitterClient.h"

@implementation Tweet

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        self.text = dictionary[@"text"];
        self.createdAt = [self formatDateWithString:dictionary[@"created_at"]];
        self.retweetsCount = [dictionary[@"retweet_count"] integerValue];
        self.favoritesCount = [dictionary[@"favorite_count"] integerValue];
        self.tweetId = [dictionary[@"id"] integerValue];
        self.favorited = [dictionary[@"favorited"] boolValue];
        self.retweeted = [dictionary[@"retweeted"] boolValue];
    }

    return self;
}

- (NSDate *)formatDateWithString:(NSString *)dateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
    return [formatter dateFromString:dateString];
}

- (void)rewtweetWithParams:(NSDictionary *)params completion:(void (^)(Tweet *tweet, NSError *error))completion {
    [[TwitterClient sharedInstance] retweetWithParams:params tweetId:self.tweetId completion:^(Tweet *tweet, NSError *error) {
        completion(tweet, error);
    }];
}

- (void)favoriteTweetWithId:(NSInteger)tweetId completion:(void (^)(Tweet *tweet, NSError *error))completion {
    [[TwitterClient sharedInstance] favoriteTweetWithId:self.tweetId completion:^(Tweet *tweet, NSError *error) {
        completion(tweet, error);
    }];
}

+ (NSArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [NSMutableArray array];

    for (NSDictionary *dictionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    
    return tweets;
}

+ (void)homeTimelineWithCompletion:(void (^)(NSArray *tweets, NSError *error))completion {
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *responseObject, NSError *error) {
        completion([self tweetsWithArray:responseObject], error);
    }];
}

+ (void)updateStatusWithParams:(NSDictionary *)params completion:(void (^)(Tweet *tweet, NSError *error))completion {
    [[TwitterClient sharedInstance] updateStatusWithParams:params completion:^(NSDictionary *responseObject, NSError *error) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet, error);
    }];
}

@end
