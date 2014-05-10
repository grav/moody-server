//
// Created by Soren Ulrikkeholm on 09/05/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "MOOMoodInputViewModel.h"
#import "MOOMoodManager.h"
#import "UIColor+MOOAdditions.h"

static CGFloat const kRegisterMoodThrottle = 2.f;

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
        return [UIColor colorForMood:moodNum.floatValue];
    }];
}

- (void)bindMoodRegistration {
    RACSignal *registerMoodSignal = [RACObserve(self, moodValue) throttle:kRegisterMoodThrottle];
    [[MOOMoodManager sharedInstance] rac_liftSelector:@selector(registerMoodValue:) withSignals:registerMoodSignal, nil];
}

- (void)bindMoodState {
    RAC(self, moodState) = [RACObserve(self, moodValue) map:^id(NSNumber *moodNum) {
        CGFloat moodValue = moodNum.floatValue;
        CGFloat relativeMoodValue = moodValue + 1 / 2.0f;

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




@end