//
// Created by Mikkel Gravgaard on 09/05/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "MOOVizViewController.h"
#import <MapKit/MapKit.h>

@interface MOOVizViewController ()<MKMapViewDelegate>

@end

@implementation MOOVizViewController {

}

- (void)loadView {
    [super loadView];
    MKMapView *mapView = [MKMapView new];
    mapView.mapType = MKMapTypeHybrid;

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

}


@end