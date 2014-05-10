//
// Created by Mikkel Gravgaard on 09/05/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "MOOMockDataGenerator.h"

@implementation MOOMockDataGenerator {

}
+ (NSArray *)randomWalkFromLocation:(CLLocationCoordinate2D)start
                              steps:(NSInteger)steps
                          startTime:(NSDate *)startTime {

    NSTimeInterval dInterval = 60;
    NSMutableArray *locations = [NSMutableArray array];
    CLLocationCoordinate2D coords = start;
    for(NSInteger step = 0; step<steps-1; step++){
        NSDate *timestamp = [startTime dateByAddingTimeInterval:dInterval * step];
        id location = [[CLLocation alloc] initWithCoordinate:coords
                                                    altitude:0
                                          horizontalAccuracy:0
                                            verticalAccuracy:0
                                                      course:kCFLocaleLanguageDirectionUnknown
                                                       speed:0
                                                   timestamp:timestamp];
        [locations addObject:location];
        coords = [self randomWalkFromLocation:coords];
    }

    return locations;
}

+ (CLLocationCoordinate2D)randomWalkFromLocation:(CLLocationCoordinate2D)start {
    CLLocationDistance dDistMax = 0.005;
    CLLocationCoordinate2D end = start;
    end.latitude += (drand48() - 0.5) * 2 * dDistMax;
    end.longitude += (drand48() - 0.5) * 2 * dDistMax;
    return end;
}

+ (CLLocationCoordinate2D)here
{
    return CLLocationCoordinate2DMake(
               55.942774, 11.681137
    );
}

@end