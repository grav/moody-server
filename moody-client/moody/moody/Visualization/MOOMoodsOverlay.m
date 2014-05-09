//
// Created by Mikkel Gravgaard on 09/05/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "MOOMoodsOverlay.h"
#import "NSArray+Functional.h"
#import "NSDate+MOOAdditions.h"

@interface MOOMoodsOverlay ()
@property (nonatomic, strong) NSArray *moods;
@property (nonatomic, strong) CLLocation *firstLocation, *lastLocation;
@end

@implementation MOOMoodsOverlay {

}

- (instancetype)init {
    if (!(self = [super init])) return nil;
    return self;
}


+ (instancetype)overlayWithMoods:(NSArray *)moods {
    MOOMoodsOverlay *overlay = [MOOMoodsOverlay new];
    overlay.moods = moods;
    return overlay;
}

- (void)setMoods:(NSArray *)moods {
    _moods = moods;

    self.firstLocation = [self.moods reduceUsingBlock:^id(CLLocation *first, CLLocation *location) {
        return [location.timestamp isBeforeDate:first.timestamp] ? location : first;
    } initialAggregation:[self.moods firstObject]];

    self.lastLocation = [self.moods reduceUsingBlock:^id(CLLocation *last, CLLocation *location) {
        return [location.timestamp isAfterDate:last.timestamp] ? location : last;
    } initialAggregation:[self.moods firstObject]];

}

- (NSArray *)moodsInRect:(MKMapRect)mapRect
{
    NSTimeInterval interval = [self.lastLocation.timestamp timeIntervalSinceDate:self.firstLocation.timestamp] * self.time + [self.firstLocation.timestamp timeIntervalSince1970];
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:interval];


    CLLocation *before = [self.moods reduceUsingBlock:^id(CLLocation *a, CLLocation *l) {
        if([l.timestamp isEqualToDate:currentDate]) return l;
        return [l.timestamp isBeforeDate:currentDate] && [l.timestamp isAfterDate:a.timestamp] ? l : a;
    } initialAggregation:self.firstLocation];

    CLLocation *after = [self.moods reduceUsingBlock:^id(CLLocation *a, CLLocation *l) {
        return [l.timestamp isAfterDate:currentDate] && [l.timestamp isBeforeDate:a.timestamp] ? l : a;
    } initialAggregation:self.lastLocation];

    MKMapPoint afterPoint = MKMapPointForCoordinate(after.coordinate);
    MKMapPoint beforePoint = MKMapPointForCoordinate(before.coordinate);
    double x = (afterPoint.x - beforePoint.x) * self.time + beforePoint.x;
    double y = (afterPoint.y - beforePoint.y) * self.time + beforePoint.y;


    CLLocation *location = [[CLLocation alloc] initWithCoordinate:MKCoordinateForMapPoint(MKMapPointMake(x, y))
                                                         altitude:0
                                               horizontalAccuracy:0
                                                 verticalAccuracy:0
                                                           course:0
                                                            speed:0
                                                        timestamp:currentDate];

    return @[before,location,after];

    // TODO - time interpolation
    // TODO - cache
    return [self.moods filterUsingBlock:^BOOL(CLLocation *location) {
        MKMapPoint mapPoint = MKMapPointForCoordinate(location.coordinate);
        return MKMapRectContainsPoint(mapRect, mapPoint);
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
    [self.moods enumerateObjectsUsingBlock:^(CLLocation *location, NSUInteger idx, BOOL *stop) {
        MKMapPoint point = MKMapPointForCoordinate(location.coordinate);
        minX = MIN(point.x,minX);
        maxX = MAX(point.x,maxX);
        minY = MIN(point.y,minY);
        maxY = MAX(point.y,maxY);
    }];
    return MKMapRectMake(minX, minY, maxX-minX, maxY-minY);
}


@end