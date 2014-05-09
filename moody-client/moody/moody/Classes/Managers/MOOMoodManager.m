//
// Created by Soren Ulrikkeholm on 09/05/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "MOOMoodManager.h"

@interface MOOMoodManager ()

@end

@implementation MOOMoodManager

+ (MOOMoodManager *)sharedInstance {
    __strong static MOOMoodManager *sharedObject = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedObject = [[self alloc] init];
    });

    return sharedObject;
}


@end