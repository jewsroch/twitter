//
//  TwitterClient.m
//  Twitter
//
//  Created by Chad Jewsbury on 11/4/15.
//  Copyright © 2015 Chad Jewsbury. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

NSString * const kTwitterConsumerKey = @"EIkIJBIMmmdZj5P6grMzJAc3z";
NSString * const kTwitterConsumerSecret = @"t8RgUNlYHltog3x3TG1fhOnP0V6bm5ZM2Fwomim65QxWNt7uvw";
NSString * const kTwitterBaseUrl = @"https://api.twitter.com";

@interface TwitterClient()

@property (nonatomic, strong) void (^loginCompletion)(User *user, NSError *error);

@end


@implementation TwitterClient

+ (TwitterClient *)sharedInstance {
    static TwitterClient *instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
        }
    });

    return instance;
}

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion {
    // Set our completion block to the self.loginCompletion propery so we can call it later.
    self.loginCompletion = completion;

    // Clean up request so we don't use an old accesToken and get a 400 error.
    [self.requestSerializer removeAccessToken];

    // -------- OAUTH 1.0A Flow ---------
    // Step 1: Fetch OAUTH Request Token from Twitter API
    // callbackURL includes app-specific protocol so redirect will open in our app.
    // That is set in the Project > Info > URL Types settings page.

    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"cjtwitterapp://oauth"] scope:nil success:^(BDBOAuth1Credential *requestToken) {

        // Step 2: (If successfully requested token) -- Navigate to authorization URL (on Twitter).
        // Create Authorization URL
        NSURL *authURl = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];

        // Open that URL
        // @TODO Open redirect url in modal window
        [[UIApplication sharedApplication] openURL:authURl];

        // After auth, the user will be redirected to cjtwitterapp://oauth which will be handled in the AppDelegate.
        // AppDelegate in turn calls openURL below...

    } failure:^(NSError *error) {
        // If can't get RequestToken, return completion block with error.
        self.loginCompletion(nil, error);
    }];

}

- (void)openURL:(NSURL *)url {
    // Step 3: Get Access Token
    // Uses Query string from the redirected url from the twitter auth page. (url.query).
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query] success:^(BDBOAuth1Credential *accessToken) {

        // Step 4: Save Access Token and start making protected requests using it!
        [self.requestSerializer saveAccessToken:accessToken];

        // Example secured call to get User Data
        // https://dev.twitter.com/rest/reference/get/account/verify_credentials
        [self GET:@"1.1/account/verify_credentials.json"
       parameters:nil
          success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            // Create user model from the response
            User *user = [[User alloc] initWithDictionary:responseObject];

            // Persist User to disk
            [User setCurrentUser:user];

            // Pass User (and no error) to the Completion handler block.
            self.loginCompletion(user, nil);

        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            // Pass error back to completion handler block.
            self.loginCompletion(nil, error);
        }];

    } failure:^(NSError *error) {
        // Return an error to the completion block if we can't get the access_token.
        self.loginCompletion(nil, error);
    }];

}

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion {
    [self GET:@"1.1/statuses/home_timeline.json"
   parameters:params
      success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        // @todo - should check if response object is actually an array... 26:00 in second movie.
        completion(responseObject, nil);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)updateStatusWithParams:(NSDictionary *)params completion:(void (^)(NSDictionary *responseObject, NSError *error))completion {
    [self POST:@"1.1/statuses/update.json"
    parameters:params
       success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        completion(responseObject, nil);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)retweetWithParams:(NSDictionary *)params tweetId:(NSInteger)tweetId completion:(void (^)(Tweet *tweet, NSError *error))completion {
    NSString *url = [NSString stringWithFormat:@"1.1/statuses/retweet/%ld.json", (long)tweetId];
    [self POST:url
    parameters:params
       success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        completion(responseObject, nil);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)favoriteTweetWithId:(NSInteger)tweetId completion:(void (^)(Tweet *tweet, NSError *error))completion {
    [self POST:@"1.1/favorites/create.json"
    parameters:@{@"id":[@(tweetId) stringValue]}
       success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
           completion(responseObject, nil);
       } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
           completion(nil, error);
       }];
}

@end
