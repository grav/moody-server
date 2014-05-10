//
// Created by Soren Ulrikkeholm on 09/05/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "MOOMoodManager.h"
#import "MOOMood.h"
#import "MOOAPIManager.h"
#import "MOOLocationManager.h"

static CGFloat const kUploadQueueThrottle = 10.f;

static NSString *const kUserId = @"userid";

@interface MOOMoodManager ()

@property (nonatomic, strong) NSArray *queue;

@property (nonatomic) NSInteger userId;

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

    NSInteger userId = [[NSUserDefaults standardUserDefaults] integerForKey:kUserId];
    if(userId==0){
        userId = arc4random();
        [[NSUserDefaults standardUserDefaults] setInteger:userId forKey:kUserId];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    self.userId = userId;


    return self;
}

- (void)registerMoodValue:(CGFloat)moodValue {
    CLLocation *location = [self currentLocation];
    MOOMood *mood = [MOOMood moodWithScore:moodValue location:location user:self.userId];
    [self enqueueMood:mood];
}

- (CLLocation *)currentLocation {
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