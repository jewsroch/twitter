//
//  UIColor+TwitterColors.m
//  Twitter
//
//  Created by Chad Jewsbury on 11/10/15.
//  Copyright © 2015 Chad Jewsbury. All rights reserved.
//

#import <UIKit/UIKit.h>

@implementation UIColor (TwitterColors)

+ (UIColor *)twitterAccentColor {
    return [UIColor colorWithRed:.33
                           green:.67
                            blue:.93
                           alpha:1];
}

+ (UIColor *)twitterActionButtonColor {
    return [UIColor colorWithRed:0.67
                           green:0.72
                            blue:0.76
                           alpha:1];
}

+ (UIColor *)twitterActionButtonOnColor {
    return [UIColor colorWithRed:0.10
                           green:0.81
                            blue:0.53
                           alpha:1];
}

+ (UIColor *)twitterLikeActionButtonOnColor {
    return [UIColor colorWithRed:0.91
                           green:0.11
                            blue:0.31
                           alpha:1];
}

@end
