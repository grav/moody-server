//
// Created by Soren Ulrikkeholm on 09/05/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "MOOMoodInputViewModel.h"

CGFloat const kMaxMoodValue = 5.f;
CGFloat const kMinMoodValue = -5.f;

@interface MOOMoodInputViewModel ()

@end

@implementation MOOMoodInputViewModel

- (id)init {
    if (!(self = [super init])) return nil;

    self.mood = 0.f;

    RAC(self, backgroundColor) = [RACObserve(self, mood) map:^id(NSNumber *mood) {
        if (mood.floatValue > 0) {
            return [self colorLerpFrom:[UIColor yellowColor] to:[UIColor greenColor] withDuration:(mood.floatValue / kMaxMoodValue)];
        }
        else if (mood.floatValue == 0) {
            return [UIColor yellowColor];
        }
        else {
            return [self colorLerpFrom:[UIColor yellowColor] to:[UIColor redColor] withDuration:(CGFloat) (fabs(mood.floatValue / kMinMoodValue))];
        }
    }];

    return self;
}


- (UIColor *)colorLerpFrom:(UIColor *)start to:(UIColor *)end withDuration:(CGFloat)t
{
    if(t < 0.0f) t = 0.0f;
    if(t > 1.0f) t = 1.0f;

    const CGFloat *startComponent = CGColorGetComponents(start.CGColor);
    const CGFloat *endComponent = CGColorGetComponents(end.CGColor);

    float startAlpha = CGColorGetAlpha(start.CGColor);
    float endAlpha = CGColorGetAlpha(end.CGColor);

    float r = startComponent[0] + (endComponent[0] - startComponent[0]) * t;
    float g = startComponent[1] + (endComponent[1] - startComponent[1]) * t;
    float b = startComponent[2] + (endComponent[2] - startComponent[2]) * t;
    float a = startAlpha + (endAlpha - startAlpha) * t;

    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}


@end