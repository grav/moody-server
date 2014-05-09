//
// Created by Soren Ulrikkeholm on 09/05/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//


@interface MOOAPIManager : NSObject
+ (RACSignal *)getMoods;
+ (RACSignal *)postMoods:(NSArray *)moods;

@end