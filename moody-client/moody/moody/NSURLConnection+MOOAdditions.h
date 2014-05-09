//
// Created by Mikkel Gravgaard on 09/05/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLConnection (MOOAdditions)
+ (RACSignal *)sendRequest:(NSURLRequest *)request responseClass:(Class)class;
@end