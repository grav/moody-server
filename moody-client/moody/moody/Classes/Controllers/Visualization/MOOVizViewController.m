//
// Created by Mikkel Gravgaard on 09/05/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "MOOVizViewController.h"
#import "MOOMockDataGenerator.h"
#import "MOOMoodRenderer.h"
#import "MOOMoodsOverlay.h"
#import "MOOAPIManager.h"
#import <MapKit/MapKit.h>


@interface MOOVizViewController ()<MKMapViewDelegate>

@property(nonatomic, strong) MOOMoodRenderer *renderer;
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



    MOOMoodsOverlay *moodsOverlay = [MOOMoodsOverlay new];
    RAC(moodsOverlay,time) = time;
    [mapView addOverlay:moodsOverlay];

    @weakify(mapView)
    [time subscribeNext:^(id x) {
        @strongify(mapView)
        [mapView removeOverlay:moodsOverlay];
        [mapView addOverlay:moodsOverlay];
    }];

    ;

    [moodsOverlay rac_liftSelector:@selector(setMoods:) withSignalsFromArray:@[[MOOAPIManager getMoods]]];

    [[[RACObserve(moodsOverlay, moods) ignore:nil] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
        @strongify(mapView)
        [mapView setVisibleMapRect:[moodsOverlay boundingMapRect]];
    }];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    self.renderer = [[MOOMoodRenderer alloc] initWithOverlay:overlay];
    return self.renderer;
}

@end