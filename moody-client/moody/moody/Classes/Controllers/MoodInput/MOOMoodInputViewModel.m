//
// Created by Soren Ulrikkeholm on 09/05/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "MOOMoodInputViewModel.h"
#import "MOOMoodManager.h"

CGFloat const kMaxMoodValue = 5.f;
CGFloat const kMinMoodValue = -kMaxMoodValue;

static CGFloat const kRegisterMoodThrottle = 10.f;

typedef NS_ENUM(NSInteger, MOOMoodState) {
    MOOMoodStateVeryHappy,
    MOOMoodStateHappy,
    MOOMoodStateMedium,
    MOOMoodStateSad,
    MOOMoodStateVerySad
};

@interface MOOMoodInputViewModel ()

@property (nonatomic, assign) MOOMoodState moodState;

@end

@implementation MOOMoodInputViewModel

- (id)init {
    if (!(self = [super init])) return nil;

    self.moodValue = 0.f;

    [self setupBindings];

    return self;
}

- (void)setupBindings {
    [self bindBackgroundColor];
    [self bindMoodRegistration];
    [self bindMoodState];
    [self bindMoodImage];
}

- (void)bindBackgroundColor {
    RAC(self, backgroundColor) = [RACObserve(self, moodValue) map:^id(NSNumber *moodNum) {
        CGFloat moodValue = moodNum.floatValue;

        if (moodValue > 0) {
            return [self colorLerpFrom:[UIColor yellowColor] to:[UIColor greenColor] withDuration:(moodValue / kMaxMoodValue)];
        }
        else if (moodValue == 0) {
            return [UIColor yellowColor];
        }
        else {
            return [self colorLerpFrom:[UIColor yellowColor] to:[UIColor redColor] withDuration:(CGFloat) (fabs(moodValue / kMinMoodValue))];
        }
    }];
}

- (void)bindMoodRegistration {
    RACSignal *registerMoodSignal = [RACObserve(self, moodValue) throttle:kRegisterMoodThrottle];
    [[MOOMoodManager sharedInstance] rac_liftSelector:@selector(registerMoodValue:) withSignals:registerMoodSignal, nil];
}

- (void)bindMoodState {
    RAC(self, moodState) = [RACObserve(self, moodValue) map:^id(NSNumber *moodNum) {
        CGFloat moodValue = moodNum.floatValue;
        CGFloat relativeMaxValue = (CGFloat) (fabs(kMinMoodValue) + kMaxMoodValue);
        CGFloat relativeMoodValue = (moodValue + kMaxMoodValue) / relativeMaxValue;

        if (relativeMoodValue > 0.8f) {
            return @(MOOMoodStateVeryHappy);
        }
        else if (relativeMoodValue > 0.6f) {
            return @(MOOMoodStateHappy);
        }
        else if (relativeMoodValue > 0.4f) {
            return @(MOOMoodStateMedium);
        }
        else if (relativeMoodValue > 0.2f) {
            return @(MOOMoodStateSad);
        }
        else {
            return @(MOOMoodStateVerySad);
        }
    }];
}

- (void)bindMoodImage {
    RAC(self, moodImage) = [RACObserve(self, moodState) map:^id(NSNumber *stateNum) {
        MOOMoodState state = (MOOMoodState) stateNum.integerValue;
        switch (state) {
            case MOOMoodStateVeryHappy: return kImgMoodVeryHappy;
            case MOOMoodStateHappy: return kImgMoodHappy;
            case MOOMoodStateSad: return kImgMoodSad;
            case MOOMoodStateVerySad: return kImgMoodVerySad;
            case MOOMoodStateMedium:
            default: return kImgMoodMedium;
        }
    }];
}

- (UIColor *)colorLerpFrom:(UIColor *)start to:(UIColor *)end withDuration:(CGFloat)t {
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


@end