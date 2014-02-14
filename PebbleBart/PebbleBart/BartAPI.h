//
//  BartAPI.h
//  PebbleBart
//
//  Created by Jordan Zucker on 2/14/14.
//  Copyright (c) 2014 Jordan Zucker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BartAPI : NSObject

+ (instancetype) sharedInstance;
- (void) getStations;

@end
