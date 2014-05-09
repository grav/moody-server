//
// Created by Mikkel Gravgaard on 09/05/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "MOOMoodsOverlay.h"
#import "NSArray+Functional.h"

@interface MOOMoodsOverlay ()
@property (nonatomic, strong) NSArray *moods;
@end

@implementation MOOMoodsOverlay {

}

+ (instancetype)overlayWithMoods:(NSArray *)moods {
    MOOMoodsOverlay *overlay = [MOOMoodsOverlay new];
    overlay.moods = moods;
    return overlay;
}


- (NSArray *)moodsInRect:(MKMapRect)mapRect
{
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