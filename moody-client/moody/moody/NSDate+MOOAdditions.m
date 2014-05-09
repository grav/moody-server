//
// Created by Mikkel Gravgaard on 09/05/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "NSDate+MOOAdditions.h"


@implementation NSDate (MOOAdditions)
- (BOOL)isBeforeDate:(NSDate *)date {
    return [self timeIntervalSinceDate:date] < 0;
}

- (BOOL)isAfterDate:(NSDate *)date {
    return [self timeIntervalSinceDate:date] > 0;
}
@end