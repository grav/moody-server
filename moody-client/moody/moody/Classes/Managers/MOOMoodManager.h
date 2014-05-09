//
// Created by Soren Ulrikkeholm on 09/05/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

@interface MOOMoodManager : NSObject

+ (MOOMoodManager *)sharedInstance;

- (void)registerMoodValue:(CGFloat)mood;

@end