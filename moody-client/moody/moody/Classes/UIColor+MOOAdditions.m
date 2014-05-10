//
// Created by Mikkel Gravgaard on 10/05/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "UIColor+MOOAdditions.h"


@implementation UIColor (MOOAdditions)
+ (UIColor *)colorLerpFrom:(UIColor *)start to:(UIColor *)end withDuration:(CGFloat)t {
    if (t < 0.0f) t = 0.0f;
    if (t > 1.0f) t = 1.0f;

    const CGFloat *startComponent = CGColorGetComponents(start.CGColor);
    const CGFloat *endComponent = CGColorGetComponents(end.CGColor);

    CGFloat startAlpha = CGColorGetAlpha(start.CGColor);
    CGFloat endAlpha = CGColorGetAlpha(end.CGColor);

    CGFloat r = startComponent[0] + (endComponent[0] - startComponent[0]) * t;
    CGFloat g = startComponent[1] + (endComponent[1] - startComponent[1]) * t;
    CGFloat b = startComponent[2] + (endComponent[2] - startComponent[2]) * t;
    CGFloat a = startAlpha + (endAlpha - startAlpha) * t;

    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}


+ (UIColor*)colorForMood:(double)moodValue
{

    if (moodValue > 0) {
        return [UIColor colorLerpFrom:[UIColor yellowColor] to:[UIColor greenColor] withDuration:moodValue];
    }
    else if (moodValue == 0) {
        return [UIColor yellowColor];
    }
    else {
        return [UIColor colorLerpFrom:[UIColor yellowColor] to:[UIColor redColor]
                         withDuration:(CGFloat) fabs(moodValue)];
    }

}

@end