//
// Created by Mikkel Gravgaard on 10/05/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MOOMood;


@interface MOOUserMoods : NSObject
@property (nonatomic, strong) NSArray *moods;

- (MOOMood *)moodForTime:(NSDate *)currentDate;
@end