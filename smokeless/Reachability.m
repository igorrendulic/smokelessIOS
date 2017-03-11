//
//  Reachability.m
//  smokeless
//
//  Created by Igor Test on 05/08/16.
//  Copyright © 2016 Igor Rendulic. All rights reserved.
//

#import "Reachability.h"

@implementation Reachability

+ (id)shared {
    static Reachability *myReachability = nil;
    @synchronized (self) {
        if (myReachability == nil) {
            myReachability = [[self alloc] init];
        }
    }
    return myReachability;
}

@end
