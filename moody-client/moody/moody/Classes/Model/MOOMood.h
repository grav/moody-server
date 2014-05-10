//
// Created by Soren Ulrikkeholm on 09/05/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//


#import "MTLModel.h"
#import "MTLJSONAdapter.h"
#import <CoreLocation/CoreLocation.h>

@interface MOOMood : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) double mood;
@property (nonatomic) double latitude, longtitude;
@property (nonatomic, strong) NSDate *timestamp;

@property(nonatomic) NSInteger userId;

@property(nonatomic) CLLocationAccuracy horizontalAccuracy;

@property(nonatomic) CLLocationAccuracy verticalAccuracy;

+ (instancetype)moodWithScore:(double)score location:(CLLocation *)location user:(NSInteger)userId;

- (CLLocation *)location;

@end