//
// Created by Soren Ulrikkeholm on 09/05/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//


@class CLLocation;

@interface MOOMood : NSObject

@property (nonatomic, assign) CGFloat mood;
@property (nonatomic, strong) CLLocation *location;

@end