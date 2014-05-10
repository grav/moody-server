//
// Created by Soren Ulrikkeholm on 09/05/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "MOOMoodManager.h"
#import "MOOMood.h"
#import "MOOAPIManager.h"
#import "MOOLocationManager.h"

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
    CLLocation *location = [self currentLocation];
    MOOMood *mood = [MOOMood moodWithScore:moodValue location:location];
    [self enqueueMood:mood];
}

- (CLLocation *)currentLocation {
    // TODO
    return [[MOOLocationManager sharedInstance] currentLocation];
}

- (void)enqueueMood:(MOOMood *)mood {
    NSLog(@"Putting mood on queue: %@", mood);

    self.queue = [self.queue arrayByAddingObject:mood];
}

- (void)uploadObjectsInQueue:(NSArray *)queue {
    NSLog(@"Uploading queue: %@", queue);
    [[MOOAPIManager postMoods:self.queue] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    } error:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    self.queue = @[];
}

@end