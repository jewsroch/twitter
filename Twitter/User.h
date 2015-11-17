//
//  User.h
//  Twitter
//
//  Created by Chad Jewsbury on 11/4/15.
//  Copyright © 2015 Chad Jewsbury. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString * const UserDidLoginNotification;
extern NSString * const UserDidLogoutNotification;

@interface User : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenname;
@property (nonatomic, strong) NSString *profileImageUrl;
@property (nonatomic, strong) NSString *tagline;
@property (nonatomic, strong) NSString *backgroundImageUrl;
@property (nonatomic, strong) NSNumber *followersCount;
@property (nonatomic, strong) NSNumber *followingCount;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) BOOL verified;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (User *)currentUser;
+ (void)setCurrentUser:(User *)currentUser;
+ (void)logout;

@end
