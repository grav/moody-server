//
// Created by Mikkel Gravgaard on 09/05/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "MOOMoodRenderer.h"
#import "NSArray+Functional.h"
#import "MOOMoodsOverlay.h"
#import "MOOMood.h"
#import "UIColor+MOOAdditions.h"


@implementation MOOMoodRenderer {

}
- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)ctx {
    [super drawMapRect:mapRect zoomScale:zoomScale inContext:ctx];
//    CGContextSetFillColorWithColor(ctx, [UIColor orangeColor].CGColor);
    CGRect rect = [self rectForMapRect:mapRect];

    CGContextSetLineWidth(ctx,2);

    MOOMoodsOverlay *overlay = (MOOMoodsOverlay *) self.overlay;


    [[overlay moodsInRect:mapRect] enumerateObjectsUsingBlock:^(MOOMood *mood, NSUInteger idx, BOOL *stop) {
        UIColor *moodColor = [UIColor colorForMood:mood.mood];
        CGContextSetFillColorWithColor(ctx, moodColor.CGColor);

        MKMapPoint mapPoint = MKMapPointForCoordinate(mood.location.coordinate);

        CGPoint point = [self pointForMapPoint:mapPoint];
        CGContextAddArc(ctx, point.x, point.y, 10 * (1.0 / zoomScale), 0.0, (CGFloat) (M_PI* 2), YES);
        CGContextFillPath(ctx);
    }];
}

@end