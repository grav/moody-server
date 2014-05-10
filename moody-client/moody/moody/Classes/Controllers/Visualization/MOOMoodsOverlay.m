//
// Created by Mikkel Gravgaard on 09/05/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "MOOMoodsOverlay.h"
#import "NSArray+Functional.h"
#import "NSDate+MOOAdditions.h"
#import "MOOMood.h"

@interface MOOMoodsOverlay ()
@property (nonatomic, strong) CLLocation *firstLocation, *lastLocation;
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

}

- (NSArray *)moodsInRect:(MKMapRect)mapRect
{
    NSTimeInterval interval = [self.lastLocation.timestamp timeIntervalSinceDate:self.firstLocation.timestamp] * self.time + [self.firstLocation.timestamp timeIntervalSince1970];
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:interval];


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

    MOOMood *mood = [MOOMood moodWithScore:moodValue location:location user:0];

    return @[mood];
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