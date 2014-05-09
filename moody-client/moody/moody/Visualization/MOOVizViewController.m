//
// Created by Mikkel Gravgaard on 09/05/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "MOOVizViewController.h"
#import "MOOMockDataGenerator.h"
#import "MOOMoodRenderer.h"
#import "MOOMoodsOverlay.h"
#import <MapKit/MapKit.h>


@interface MOOVizViewController ()<MKMapViewDelegate>

@property(nonatomic) MKMapRect rect;
@end

@implementation MOOVizViewController {

}

- (void)updateOnClassInjection
{
    [self loadView];
}

- (void)loadView {
    [super loadView];
    MKMapView *mapView = [MKMapView new];
    mapView.mapType = MKMapTypeHybrid;
    mapView.showsUserLocation = YES;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.location.coordinate, 1000, 1000);
    [mapView setRegion:region];
    mapView.delegate = self;

    UISlider *slider = [UISlider new];
    [@[mapView, slider] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.view addSubview:obj];
    }];

    [mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mapView.superview);
        make.left.equalTo(mapView.superview);
        make.right.equalTo(mapView.superview);
        make.bottom.equalTo(slider.mas_top);
    }];

    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(slider.superview);
        make.right.equalTo(slider.superview);
        make.bottom.equalTo(slider.superview);
    }];


    RACSignal *time = [[slider rac_signalForControlEvents:UIControlEventValueChanged] map:^id(UISlider *slider1) {
        return @(slider1.value);
    }];

    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(
            55.942774, 11.681137
    );

    NSArray *locations = [MOOMockDataGenerator randomWalkFromLocation:location
                                                                steps:10
                                                            startTime:[NSDate date]];

    MOOMoodsOverlay *moodsOverlay = [MOOMoodsOverlay overlayWithMoods:locations];
    [mapView addOverlay:moodsOverlay];

    [mapView setVisibleMapRect:[moodsOverlay boundingMapRect]];

}


- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    MOOMoodRenderer *renderer = [[MOOMoodRenderer alloc] initWithOverlay:overlay];
    return renderer;
}

@end