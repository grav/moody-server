//
// Created by Soren Ulrikkeholm on 09/05/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import <NSArray+Functional/NSArray+Functional.h>
#import "MOOAPIManager.h"
#import "MOOMood.h"
#import "NSURLConnection+MOOAdditions.h"

static NSString *const kUrl = @"http://localhost:3000/moods";

@interface MOOAPIManager ()

@end

@implementation MOOAPIManager

+ (RACSignal *)getMoods {
    return [NSURLConnection sendRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kUrl]]
                          responseClass:[MOOMood class]];
}

+ (RACSignal *)postMoods:(NSArray *)moods {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kUrl]];
    NSArray *json = [moods mapUsingBlock:^id(MOOMood *mood) {
        return [MTLJSONAdapter JSONDictionaryFromModel:mood];
    }];

    NSError *jsonError;
    NSData *data = [NSJSONSerialization dataWithJSONObject:json
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&jsonError];
    NSCAssert(!jsonError, @"%@",jsonError);

    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    return [NSURLConnection rac_sendAsynchronousRequest:request];
}



@end