//
// Created by Mikkel Gravgaard on 09/05/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "MOOMoodRenderer.h"
#import "NSArray+Functional.h"
#import "MOOMoodsOverlay.h"


@implementation MOOMoodRenderer {

}
- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)ctx {
    [super drawMapRect:mapRect zoomScale:zoomScale inContext:ctx];
//    CGContextSetFillColorWithColor(ctx, [UIColor orangeColor].CGColor);
    CGRect rect = [self rectForMapRect:mapRect];

    CGContextSetLineWidth(ctx,2);

    MOOMoodsOverlay *overlay = (MOOMoodsOverlay *) self.overlay;

    CGContextSetFillColorWithColor(ctx, [UIColor orangeColor].CGColor);


    [[overlay moodsInRect:mapRect] enumerateObjectsUsingBlock:^(CLLocation *location, NSUInteger idx, BOOL *stop) {
        MKMapPoint mapPoint = MKMapPointForCoordinate(location.coordinate);

        CGPoint point = [self pointForMapPoint:mapPoint];
        NSCAssert(CGRectContainsPoint(rect, point), @"");

        CGContextAddArc(ctx, point.x, point.y, 200, 0.0, (CGFloat) (M_PI* 2), YES);
        CGContextFillPath(ctx);
    }];
}

@end