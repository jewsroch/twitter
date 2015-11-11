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

- (NSString *)formatDateWithString:(NSString*)postDate{

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    NSDate *userPostDate = [df dateFromString:postDate];


    NSDate *currentDate = [NSDate date];
    NSTimeInterval distanceBetweenDates = [currentDate timeIntervalSinceDate:userPostDate];

    NSTimeInterval theTimeInterval = distanceBetweenDates;

    // Get the system calendar
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];

    // Create the NSDates
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:theTimeInterval sinceDate:date1];

    // Get conversion to months, days, hours, minutes
    unsigned int unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitSecond;

    NSDateComponents *conversionInfo = [sysCalendar components:unitFlags fromDate:date1  toDate:date2  options:0];

    NSString *returnDate;
    if ([conversionInfo month] > 0) {
        returnDate = [NSString stringWithFormat:@"%ldmth ago",(long)[conversionInfo month]];
    }else if ([conversionInfo day] > 0){
        returnDate = [NSString stringWithFormat:@"%ldd ago",(long)[conversionInfo day]];
    }else if ([conversionInfo hour]>0){
        returnDate = [NSString stringWithFormat:@"%ldh ago",(long)[conversionInfo hour]];
    }else if ([conversionInfo minute]>0){
        returnDate = [NSString stringWithFormat:@"%ldm ago",(long)[conversionInfo minute]];
    }else{
        returnDate = [NSString stringWithFormat:@"%lds ago",(long)[conversionInfo second]];
    }
    return returnDate;
}

- (void)retweetWithParams:(NSDictionary *)params completion:(void (^)(Tweet *tweet, NSError *error))completion {
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

+ (void)updateStatusWithReply:(Tweet *)replyTweet params:(NSDictionary *)params completion:(void (^)(Tweet *tweet, NSError *error))completion {
    [params setValue:@(replyTweet.tweetId) forKey:@"in_reply_to_status_id"];

    [[TwitterClient sharedInstance] updateStatusWithParams:params completion:^(NSDictionary *responseObject, NSError *error) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet, error);
    }];
}

@end
