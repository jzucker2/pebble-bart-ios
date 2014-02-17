//
//  Pebble.h
//  PebbleBart
//
//  Created by Jordan Zucker on 2/16/14.
//  Copyright (c) 2014 Jordan Zucker. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PBWatch;

@interface Pebble : NSObject

//@property (nonatomic, strong) PBWatch *targetWatch;

+ (instancetype) sharedInstance;
- (void) setUp;

- (PBWatch *) targetWatch;
- (void) sendDictToPhone:(NSDictionary *)dict;
- (void) sendResetTrigger;



@end
