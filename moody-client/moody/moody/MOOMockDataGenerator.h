//
// Created by Mikkel Gravgaard on 09/05/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MOOMockDataGenerator : NSObject

+ (NSArray *)randomWalkFromLocation:(CLLocationCoordinate2D)start steps:(NSInteger)steps startTime:(NSDate *)startTime;

+ (CLLocationCoordinate2D)here;
@end