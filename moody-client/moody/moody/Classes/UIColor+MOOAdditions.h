//
// Created by Mikkel Gravgaard on 10/05/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIColor (MOOAdditions)
+ (UIColor *)colorLerpFrom:(UIColor *)start to:(UIColor *)end withDuration:(CGFloat)t;

+ (UIColor *)colorForMood:(double)moodValue;
@end