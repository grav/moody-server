//
// Created by Soren Ulrikkeholm on 09/05/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//


#import "MTLModel.h"
#import "MTLJSONAdapter.h"
@class CLLocation;

@interface MOOMood : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) CGFloat mood;
@property (nonatomic) double latitude, longtitude;
@property (nonatomic, strong) NSDate *timestamp;

+ (instancetype)moodWithScore:(CGFloat)score location:(CLLocation*)location;

- (CLLocation *)location;

@end