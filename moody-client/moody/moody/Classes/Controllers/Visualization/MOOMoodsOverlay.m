//
// Created by Mikkel Gravgaard on 09/05/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "MOOMoodsOverlay.h"
#import "NSArray+Functional.h"
#import "NSDate+MOOAdditions.h"
#import "MOOMood.h"
#import "MOOUserMoods.h"

@interface MOOMoodsOverlay ()
@property (nonatomic, strong) CLLocation *firstLocation, *lastLocation;
@property (nonatomic, strong) NSArray *userMoods;
@end

@implementation MOOMoodsOverlay {

}

- (void)setMoods:(NSArray *)moods {
    _moods = moods;

    self.firstLocation = [self.moods reduceUsingBlock:^id(MOOMood *first, CLLocation *location) {
        return [location.timestamp isBeforeDate:first.timestamp] ? location : first;
    } initialAggregation:[self.moods firstObject]];

    self.lastLocation = [self.moods reduceUsingBlock:^id(MOOMood *last, CLLocation *location) {
        return [location.timestamp isAfterDate:last.timestamp] ? location : last;
    } initialAggregation:[self.moods firstObject]];

    NSArray *userIds = [moods mapUsingBlock:^id(MOOMood *mood) {
        return @(mood.userId);
    }];
    NSSet *uniqueIds = [NSSet setWithArray:userIds];

    self.userMoods = [[[uniqueIds allObjects] mapUsingBlock:^id(NSNumber *userId) {
        return [moods filterUsingBlock:^BOOL(MOOMood *mood) {
            return mood.userId == userId.integerValue;
        }];
    }] mapUsingBlock:^id(NSArray *filteredMoods) {
        MOOUserMoods *userMoods = [MOOUserMoods new];
        userMoods.moods =  filteredMoods;
        return userMoods;
    }];

}

- (NSArray *)moodsInRect:(MKMapRect)mapRect
{
    NSTimeInterval interval = [self.lastLocation.timestamp timeIntervalSinceDate:self.firstLocation.timestamp] * self.time + [self.firstLocation.timestamp timeIntervalSince1970];
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:interval];
    return [self.userMoods mapUsingBlock:^id(MOOUserMoods *userMoods) {
        return [userMoods moodForTime:currentDate];
    }];
}

- (CLLocationCoordinate2D)coordinate {
    CLLocation *location = [self.moods firstObject];
    return location.coordinate;
}

- (MKMapRect)boundingMapRect {

    __block double minX,maxX,minY,maxY;
    minX = DBL_MAX; minY = DBL_MAX;
    maxX = DBL_MIN; maxY = DBL_MIN;
    [self.moods enumerateObjectsUsingBlock:^(MOOMood *mood, NSUInteger idx, BOOL *stop) {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(mood.latitude, mood.longtitude);
        MKMapPoint point = MKMapPointForCoordinate(coordinate);
        minX = MIN(point.x,minX);
        maxX = MAX(point.x,maxX);
        minY = MIN(point.y,minY);
        maxY = MAX(point.y,maxY);
    }];
    return MKMapRectMake(minX, minY, maxX-minX, maxY-minY);
}


@end