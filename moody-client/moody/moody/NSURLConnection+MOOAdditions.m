//
// Created by Mikkel Gravgaard on 09/05/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import <NSArray+Functional/NSArray+Functional.h>
#import "NSURLConnection+MOOAdditions.h"
#import "MTLJSONAdapter.h"


@implementation NSURLConnection (MOOAdditions)
+ (RACSignal *)sendRequest:(NSURLRequest *)request responseClass:(Class)class {
    return [[[NSURLConnection rac_sendAsynchronousRequest:request] map:^id(RACTuple *tuple) {
        RACTupleUnpack(NSURLResponse *response, NSData *data)= tuple;
        NSError *jsonError;
        id json = [NSJSONSerialization JSONObjectWithData:data
                                                  options:0
                                                    error:&jsonError];
        NSCAssert(!jsonError, @"%@", jsonError);
        id obj;

        if ([json isKindOfClass:[NSArray class]]) {
            obj = [json mapUsingBlock:^id(NSDictionary *jsonDict) {
                NSError *mtlError;
                id obj2 = [MTLJSONAdapter modelOfClass:class
                                    fromJSONDictionary:jsonDict error:&mtlError];
                NSCAssert(!mtlError, @"%@", mtlError);
                return obj2;
            }];
        } else {
            NSError *mtlError;
            obj = [MTLJSONAdapter modelOfClass:class
                            fromJSONDictionary:json error:&mtlError];
            NSCAssert(!mtlError, @"%@", mtlError);
        }

        return obj;
    }] deliverOn:[RACScheduler mainThreadScheduler]];

}

@end