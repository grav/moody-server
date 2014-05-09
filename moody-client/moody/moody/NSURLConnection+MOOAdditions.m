//
// Created by Mikkel Gravgaard on 09/05/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "NSURLConnection+MOOAdditions.h"
#import "MTLJSONAdapter.h"


@implementation NSURLConnection (MOOAdditions)
+ (RACSignal *)sendRequest:(NSURLRequest *)request responseClass:(Class)class {
    return [[NSURLConnection rac_sendAsynchronousRequest:request] map:^id(RACTuple *tuple) {
        RACTupleUnpack(NSURLResponse*response,NSData *data)= tuple;
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:0
                                                               error:&jsonError];
        NSCAssert(!jsonError, @"%@", jsonError);

        NSError *mtlError;
        id obj = [MTLJSONAdapter modelOfClass:class
                           fromJSONDictionary:json error:&mtlError];
        NSCAssert(!mtlError, @"%@", mtlError);

        return obj;
    }];

}

@end