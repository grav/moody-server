//
// Created by Soren Ulrikkeholm on 09/05/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "MOOMoodManager.h"
#import "MOOMood.h"

static CGFloat const kUploadQueueThrottle = 60.f;

@interface MOOMoodManager ()

@property (nonatomic, strong) NSArray *queue;

@end

@implementation MOOMoodManager

+ (MOOMoodManager *)sharedInstance {
    __strong static MOOMoodManager *sharedObject = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedObject = [[self alloc] init];
    });

    return sharedObject;
}

- (id)init {
    if (!(self = [super init])) return nil;

    self.queue = [NSArray array];

    RACSignal *queueIsReadyToUploadSignal = [[RACObserve(self, queue) skip:1] throttle:kUploadQueueThrottle];
    [self rac_liftSelector:@selector(uploadObjectsInQueue:) withSignals:queueIsReadyToUploadSignal, nil];

    return self;
}

- (void)registerMoodValue:(CGFloat)moodValue {
    NSDate *now = [NSDate date];
    CLLocation *location = [self currentLocation];
    MOOMood *mood = [MOOMood new];
    mood.date = now;
    mood.location = location;
    mood.mood = moodValue;
    [self enqueueMood:mood];
}

- (CLLocation *)currentLocation {
    return nil;
}

- (void)enqueueMood:(MOOMood *)mood {
    NSLog(@"Putting mood on queue: %@", mood);

    self.queue = [self.queue arrayByAddingObject:mood];
}

- (void)uploadObjectsInQueue:(NSArray *)queue {
    NSLog(@"Uploading queue: %@", queue);
}

@end