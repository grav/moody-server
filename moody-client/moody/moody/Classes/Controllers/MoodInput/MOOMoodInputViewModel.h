//
// Created by Soren Ulrikkeholm on 09/05/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

extern CGFloat const kMaxMoodValue;
extern CGFloat const kMinMoodValue;

@interface MOOMoodInputViewModel : NSObject

@property (nonatomic, assign) CGFloat moodValue;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIImage *moodImage;

@end