//
// Created by Soren Ulrikkeholm on 09/05/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "MOOMood.h"
#import "MTLValueTransformer.h"

@interface MOOMood ()

@end

@implementation MOOMood

+ (instancetype)moodWithScore:(CGFloat)score location:(CLLocation *)location {
    MOOMood *mood = [MOOMood new];
    mood.latitude = location.coordinate.latitude;
    mood.longtitude = location.coordinate.longitude;
    mood.mood = score;

    return mood;
}

- (CLLocation *)location {
    return [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(self.latitude, self.longtitude)
                                         altitude:0
                               horizontalAccuracy:0
                                 verticalAccuracy:0
                                           course:0 speed:0
                                        timestamp:self.timestamp];
}

#pragma mark - JSON serialization

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{};
}



@end