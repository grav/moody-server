//
// Created by Mikkel Gravgaard on 10/05/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <NSArray+Functional/NSArray+Functional.h>
#import <MapKit/MapKit.h>
#import "MOOUserMoods.h"
#import "MOOMood.h"
#import "NSDate+MOOAdditions.h"

@interface MOOUserMoods ()
@property (nonatomic, strong) MOOMood *firstLocation, *lastLocation;
@end

@implementation MOOUserMoods {

}

- (void)setMoods:(NSArray *)moods {
    _moods = moods;
    self.firstLocation = [moods reduceUsingBlock:^id(MOOMood *first, CLLocation *location) {
        return [location.timestamp isBeforeDate:first.timestamp] ? location : first;
    } initialAggregation:[moods firstObject]];

    self.lastLocation = [moods reduceUsingBlock:^id(MOOMood *last, CLLocation *location) {
        return [location.timestamp isAfterDate:last.timestamp] ? location : last;
    } initialAggregation:[moods firstObject]];




}

- (MOOMood *)moodForTime:(NSDate *)currentDate
{
    MOOMood *before = [self.moods reduceUsingBlock:^id(MOOMood *a, MOOMood *l) {
        if([l.timestamp isEqualToDate:currentDate]) return l;
        return [l.timestamp isBeforeDate:currentDate] && [l.timestamp isAfterDate:a.timestamp] ? l : a;
    } initialAggregation:self.firstLocation];

    MOOMood *after = [self.moods reduceUsingBlock:^id(MOOMood *a, MOOMood *l) {
        return [l.timestamp isAfterDate:currentDate] && [l.timestamp isBeforeDate:a.timestamp] ? l : a;
    } initialAggregation:self.lastLocation];

    double norm = (currentDate.timeIntervalSince1970 - before.timestamp.timeIntervalSince1970) / (after.timestamp.timeIntervalSince1970 - before.timestamp.timeIntervalSince1970);

    MKMapPoint afterPoint = MKMapPointForCoordinate(CLLocationCoordinate2DMake(after.latitude, after.longtitude));
    MKMapPoint beforePoint = MKMapPointForCoordinate(CLLocationCoordinate2DMake(before.latitude, before.longtitude));
    double x = (afterPoint.x - beforePoint.x) * norm + beforePoint.x;
    double y = (afterPoint.y - beforePoint.y) * norm + beforePoint.y;

    double moodValue = (after.mood - before.mood) * norm + before.mood;

    CLLocation *location = [[CLLocation alloc] initWithCoordinate:MKCoordinateForMapPoint(MKMapPointMake(x, y))
                                                         altitude:0
                                               horizontalAccuracy:0
                                                 verticalAccuracy:0
                                                           course:0
                                                            speed:0
                                                        timestamp:currentDate];

    return [MOOMood moodWithScore:moodValue location:location user:0];

}

@end