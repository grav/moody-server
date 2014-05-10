//
// Created by Mikkel Gravgaard on 09/05/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface MOOMoodsOverlay : NSObject<MKOverlay>
@property (nonatomic, strong) NSArray *moods;
@property (nonatomic) double time;
- (NSArray *)moodsInRect:(MKMapRect)mapRect;



@end