//
//  User.m
//  Twitter
//
//  Created by Chad Jewsbury on 11/4/15.
//  Copyright © 2015 Chad Jewsbury. All rights reserved.
//

#import "User.h"
#import "TwitterClient.h"

NSString * const UserDidLoginNotification = @"UserDidLoginNotification";
NSString * const UserDidLogoutNotification = @"UserDidLogoutNotification";

@interface User()

@property (nonatomic, strong) NSDictionary *dictionary;

@end


@implementation User

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];

    if (self) {
        self.dictionary = dictionary;
        self.name = dictionary[@"name"];
        self.screenname = dictionary[@"screen_name"];
        self.tagline = dictionary[@"description"];
        self.profileImageUrl = dictionary[@"profile_image_url"];
        self.backgroundImageUrl = dictionary[@"profile_banner_url"];
        self.followersCount = dictionary[@"followers_count"];
        self.followingCount = dictionary[@"friends_count"];
        self.location = dictionary[@"location"] ? dictionary[@"location"] : nil;
        self.url = dictionary[@"url"] ? dictionary[@"url"] : nil;
        self.verified = dictionary[@"verified"];
    }

    return self;
}

static User *_currentUser = nil;

NSString *const kCurrentUserKey = @"kCurrentUserKey";

+ (User *)currentUser {
    // After cold start, or if not logged in...
    if (_currentUser == nil) {
        // Get NSUser Defaults value for kCurrentUserKey
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUserKey];

        // If there is data saved (from a previous login) use it and return our User.
        if (data != nil) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            _currentUser = [[User alloc] initWithDictionary:dictionary];
        }
    }

    return _currentUser;
}

+ (void)setCurrentUser:(User *)currentUser {
    _currentUser = currentUser;

    if (_currentUser != nil) {
        // The data from the API may contain NSNil objects. However, NSUserDefaults conforms to the PList standard and cannot include NSNil type data.
        // So we need to serialize the data into a JSON object before we save it.
        NSData *data = [NSJSONSerialization dataWithJSONObject:currentUser.dictionary options:0 error:NULL];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCurrentUserKey];
        // Don't forget to synchronize!!
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        // Clear out any existing user.
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kCurrentUserKey];
        // Don't forget to synchronize!!
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (void)logout {
    [User setCurrentUser:nil];
    [[TwitterClient sharedInstance].requestSerializer removeAccessToken];

    [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotification object:nil];
}

@end
