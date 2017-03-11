//
//  Reachability.h
//  smokeless
//
//  Created by Igor Test on 05/08/16.
//  Copyright © 2016 Igor Rendulic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Reachability : NSObject

@property (nonatomic) BOOL isConnected;

+(id)shared;

@end
