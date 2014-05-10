//
// Created by Soren Ulrikkeholm on 10/05/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

@class CLLocation;

@interface MOOLocationManager : NSObject

+ (MOOLocationManager *)sharedInstance;

@property (nonatomic, strong) CLLocation *currentLocation;

@end