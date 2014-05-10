//
// Created by Soren Ulrikkeholm on 10/05/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "MOOLocationManager.h"

@interface MOOLocationManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation MOOLocationManager

+ (MOOLocationManager *)sharedInstance {
    __strong static MOOLocationManager *sharedObject = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedObject = [[self alloc] init];
    });

    return sharedObject;
}

- (id)init {
    if (!(self = [super init])) return nil;

    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;

    [self.locationManager startUpdatingLocation];

    return self;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    self.currentLocation = newLocation;
}


@end